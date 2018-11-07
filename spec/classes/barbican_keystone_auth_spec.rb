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
# Unit tests for barbican::keystone::auth class
#
require 'spec_helper'

describe 'barbican::keystone::auth' do
  shared_examples 'barbican::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        {
          :password => 'barbican_password',
          :tenant   => 'foobar'
        }
      end

      it { should contain_keystone_user('barbican').with(
        :ensure   => 'present',
        :password => 'barbican_password',
      )}

      it { should contain_keystone_user_role('barbican@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { should contain_keystone_service('barbican::key-manager').with(
        :ensure      => 'present',
        :description => 'Key management Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/barbican::key-manager').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9311',
        :admin_url    => 'http://127.0.0.1:9311',
        :internal_url => 'http://127.0.0.1:9311',
      )}
    end

    context 'when overriding URL parameters' do
      let :params do
        {
          :password     => 'barbican_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81'
        }
      end

      it { should contain_keystone_endpoint('RegionOne/barbican::key-manager').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81'
      )}
    end

    context 'when overriding auth name' do
      let :params do
        {
          :password => 'foo',
          :auth_name => 'barbicany'
        }
      end

      it { should contain_keystone_user('barbicany') }
      it { should contain_keystone_user_role('barbicany@services') }
      it { should contain_keystone_service('barbican::key-manager') }
      it { should contain_keystone_endpoint('RegionOne/barbican::key-manager') }
    end

    context 'when overriding service name' do
      let :params do
        {
          :service_name => 'barbican_service',
          :auth_name    => 'barbican',
          :password     => 'barbican_password'
        }
      end

      it { should contain_keystone_user('barbican') }
      it { should contain_keystone_user_role('barbican@services') }
      it { should contain_keystone_service('barbican_service::key-manager') }
      it { should contain_keystone_endpoint('RegionOne/barbican_service::key-manager') }
    end

    context 'when disabling user configuration' do
      let :params do
        {
          :password       => 'barbican_password',
          :configure_user => false
        }
      end

      it { should_not contain_keystone_user('barbican') }
      it { should contain_keystone_user_role('barbican@services') }

      it { should contain_keystone_service('barbican::key-manager').with(
        :ensure      => 'present',
        :description => 'Key management Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :password            => 'barbican_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { should_not contain_keystone_user('barbican') }
      it { should_not contain_keystone_user_role('barbican@services') }

      it { should contain_keystone_service('barbican::key-manager').with(
        :ensure      => 'present',
        :description => 'Key management Service'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'barbican::keystone::auth'
    end
  end
end
