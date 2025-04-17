#
# Copyright (C) 2016 Red Hat Inc. <licensing@redhat.com>
#
# Author: Ade Lee <alee@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for barbican::api class
#
require 'spec_helper'

describe 'barbican::api' do

  shared_examples_for 'barbican api' do

    let :default_params do
      {
        :max_allowed_secret_in_bytes       => '<SERVICE DEFAULT>',
        :max_allowed_request_size_in_bytes => '<SERVICE DEFAULT>',
        :manage_service                    => true,
        :enabled                           => true,
        :enabled_secretstore_plugins       => ['<SERVICE DEFAULT>'],
        :enabled_crypto_plugins            => ['<SERVICE DEFAULT>'],
        :auth_strategy                     => 'keystone',
        :service_name                      => platform_params[:service_name],
        :enable_proxy_headers_parsing      => '<SERVICE DEFAULT>',
        :max_request_body_size             => '<SERVICE DEFAULT>',
        :max_limit_paging                  => '<SERVICE DEFAULT>',
        :default_limit_paging              => '<SERVICE DEFAULT>',
        :multiple_secret_stores_enabled    => false,
        :enabled_secret_stores             => 'simple_crypto',
      }
    end

    [
      {},
      {
        :manage_service                    => true,
        :enabled                           => false,
        :enabled_secretstore_plugins       => ['dogtag_crypto', 'store_crypto', 'kmip'],
        :enabled_crypto_plugins            => ['simple_crypto'],
        :max_allowed_secret_in_bytes       => 20000,
        :max_allowed_request_size_in_bytes => 2000000,
        :enable_proxy_headers_parsing      => false,
        :max_request_body_size             => '102400',
        :max_limit_paging                  => 100,
        :default_limit_paging              => 10,
        :multiple_secret_stores_enabled    => true,
        :enabled_secret_stores             => 'simple_crypto,dogtag,kmip',
      }
    ].each do |param_set|
      describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
        let :pre_condition do
          'class { "barbican::keystone::authtoken": password => "secret", }
          include apache'
        end

        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          default_params.merge(param_set)
        end

        it { is_expected.to contain_class('barbican::deps') }
        it { is_expected.to contain_class('barbican::db') }
        it { is_expected.to contain_class('barbican::policy') }

        it { is_expected.to contain_package('barbican-api').with(
            :tag => ['openstack', 'barbican-package'],
         )}

        it 'is_expected.to set default parameters' do
          [
            'max_allowed_secret_in_bytes',
            'max_allowed_request_size_in_bytes',
          ].each do |config|
            is_expected.to contain_barbican_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
          end
        end

        it 'configures enabled plugins' do
          is_expected.to contain_barbican_config('secretstore/enabled_secretstore_plugins') \
            .with_value(param_hash[:enabled_secretstore_plugins])
          is_expected.to contain_barbican_config('crypto/enabled_crypto_plugins') \
            .with_value(param_hash[:enabled_crypto_plugins])
        end

        it 'configures plugins in multiple plugin config' do
          is_expected.to contain_barbican_config('secretstore/stores_lookup_suffix') \
            .with_value(param_hash[:enabled_secret_stores])
          is_expected.to contain_barbican_config('secretstore/enable_multiple_secret_stores') \
            .with_value(param_hash[:multiple_secret_stores_enabled])
        end
      end
    end

    describe 'with enable_proxy_headers_parsing' do
      let :pre_condition do
        'class { "barbican::keystone::authtoken": password => "secret", }
        include apache'
      end

      let :params do
        default_params.merge!({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_oslo__middleware('barbican_config').with(
        :enable_proxy_headers_parsing => true,
      )}
    end

    describe 'with max_request_body_size' do
      let :pre_condition do
        'class { "barbican::keystone::authtoken": password => "secret", }
        include apache'
      end

      let :params do
        default_params.merge!({:max_request_body_size => '102400' })
      end

      it { is_expected.to contain_oslo__middleware('barbican_config').with(
        :max_request_body_size => '102400',
      )}
    end

    describe 'with keystone auth' do
      let :pre_condition do
        'class { "barbican::keystone::authtoken": password => "secret", }
         include apache'
      end

      let :params do
        default_params.merge({
          :auth_strategy => 'keystone',
        })
      end

      it 'is_expected.to set keystone params correctly' do
        is_expected.to contain_class('barbican::keystone::authtoken')
      end
    end
  end

  shared_examples_for 'barbican api redhat' do
    let :param_hash do
      {
        :manage_service => true,
        :enabled        => true,
        :auth_strategy  => 'keystone',
      }
    end
    let :pre_condition do
      'class { "barbican::keystone::authtoken": password => "secret", }'
    end
    context 'redhat systems eventlet service enabled' do
      describe 'should contain eventlet service' do
        it { is_expected.to contain_service('barbican-api').with(
          'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
          'enable'     => param_hash[:enabled],
          'hasstatus'  => true,
          'hasrestart' => true,
          'tag'        => 'barbican-service',
        ) }
      end
    end
    context 'on redhat systems eventlet service disabled' do
      describe 'with disabled service managing' do
        let :params do
          {
            :manage_service => false,
            :enabled        => false,
          }
        end

        it { is_expected.to_not contain_service('barbican-api') }
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      case facts[:os]['family']
      when 'RedHat'
        let (:platform_params) do
          { :service_name => 'openstack-barbican-api' }
        end
        it_behaves_like 'barbican api redhat'
      when 'Debian'
        let (:platform_params) do
          { :service_name => 'httpd' }
        end
      end

      it_behaves_like 'barbican api'
    end
  end
end
