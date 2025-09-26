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

  shared_examples_for 'barbican::api' do
    let :pre_condition do
      <<-EOS
      class { "barbican::keystone::authtoken":
        password => "secret",
      }
      include apache
EOS
    end

    context 'with defaults' do
      let :params do
        {
          :service_name => 'httpd'
        }
      end

      it { is_expected.to contain_class('barbican::deps') }
      it { is_expected.to contain_class('barbican::db') }
      it { is_expected.to contain_class('barbican::policy') }

      it { is_expected.to contain_package('barbican-api').with(
        :ensure => 'present',
        :name   => platform_params[:package_name],
        :tag    => ['openstack', 'barbican-package'],
       )}

      it 'sets default parameters' do
        is_expected.to contain_barbican_config('secretstore/enabled_secretstore_plugins').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('crypto/enabled_crypto_plugins').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('secretstore/enable_multiple_secret_stores').with_value(false)
        is_expected.to contain_barbican_config('secretstore/stores_lookup_suffix').with_value('simple_crypto')

        is_expected.to contain_barbican_config('DEFAULT/db_auto_create').with_value('<SERVICE DEFAULT>')

        is_expected.to contain_oslo__middleware('barbican_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
          :max_request_body_size        => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_barbican_config('DEFAULT/max_limit_paging').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('DEFAULT/default_limit_paging').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :service_name                      => 'httpd',
          :enabled_secretstore_plugins       => ['dogtag_crypto', 'store_crypto', 'kmip'],
          :enabled_crypto_plugins            => ['simple_crypto'],
          :multiple_secret_stores_enabled    => true,
          :enabled_secret_stores             => ['simple_crypto', 'dogtag', 'kmip'],
          :db_auto_create                    => false,
          :max_allowed_secret_in_bytes       => 20000,
          :max_allowed_request_size_in_bytes => 2000000,
          :enable_proxy_headers_parsing      => false,
          :max_request_body_size             => 102400,
          :max_limit_paging                  => 100,
          :default_limit_paging              => 10,
        }
      end

      it 'sets the provided parameters' do
        is_expected.to contain_barbican_config('secretstore/enabled_secretstore_plugins').with_value(['dogtag_crypto', 'store_crypto', 'kmip'])
        is_expected.to contain_barbican_config('crypto/enabled_crypto_plugins').with_value(['simple_crypto'])
        is_expected.to contain_barbican_config('secretstore/enable_multiple_secret_stores').with_value(true)
        is_expected.to contain_barbican_config('secretstore/stores_lookup_suffix').with_value('simple_crypto,dogtag,kmip')

        is_expected.to contain_barbican_config('DEFAULT/db_auto_create').with_value(false)

        is_expected.to contain_oslo__middleware('barbican_config').with(
          :enable_proxy_headers_parsing => false,
          :max_request_body_size        => 102400,
        )
        is_expected.to contain_barbican_config('DEFAULT/max_limit_paging').with_value(100)
        is_expected.to contain_barbican_config('DEFAULT/default_limit_paging').with_value(10)
      end
    end
  end

  shared_examples_for 'barbican::api in RedHat' do
    let :pre_condition do
      <<-EOS
      class { "barbican::keystone::authtoken":
        password => "secret",
      }
EOS
    end

    context 'with defaults' do
      it { is_expected.to contain_service('barbican-api').with(
        :ensure     => 'running',
        :name       => platform_params[:service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'barbican-service',
      )}
      it { is_expected.to contain_file_line('Modify bind_port in gunicorn-config.py').with(
        :path  => '/etc/barbican/gunicorn-config.py',
        :line  => 'bind = \'0.0.0.0:9311\'',
        :match => '^bind = .*',
        :tag   => 'modify-bind-port',
      ) }
    end
  end

  shared_examples_for 'barbican::api in Debian' do
    let :pre_condition do
      <<-EOS
      class { "barbican::keystone::authtoken":
        password => "secret",
      }
EOS
    end

    context 'with defaults' do
      it { is_expected.to contain_service('barbican-api').with(
        :ensure     => 'running',
        :name       => platform_params[:service_name],
        :enabled    => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'barbican-service',
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'RedHat'
          {
            :package_name => 'openstack-barbican-api',
            :service_name => 'openstack-barbican-api'
          }
        when 'Debian'
          case facts[:os]['name']
          when 'Debian'
            {
              :package_name => 'barbican-api',
              :service_name => 'barbican-api'
            }
          when 'Ubuntu'
            {
              :package_name => 'barbican-api',
            }
          end
        end
      end

      it_behaves_like 'barbican::api'
      case facts[:os]['family']
      when 'RedHat'
        it_behaves_like 'barbican::api in RedHat'
      when 'Deiban'
        if facts[:os]['name'] == 'Debian'
          it_behaves_like 'barbican::api in Debian'
        end
      end
    end
  end
end
