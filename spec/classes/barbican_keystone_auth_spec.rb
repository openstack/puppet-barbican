#
# Unit tests for barbican::keystone::auth
#

require 'spec_helper'

describe 'barbican::keystone::auth' do
  shared_examples_for 'barbican::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'barbican_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('barbican').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'barbican',
        :service_type        => 'key-manager',
        :service_description => 'Key management Service',
        :region              => 'RegionOne',
        :auth_name           => 'barbican',
        :password            => 'barbican_password',
        :email               => 'barbican@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:9311',
        :internal_url        => 'http://127.0.0.1:9311',
        :admin_url           => 'http://127.0.0.1:9311',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'barbican_password',
          :auth_name           => 'alt_barbican',
          :email               => 'alt_barbican@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Key management Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_key-manager',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('barbican').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_key-manager',
        :service_description => 'Alternative Key management Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_barbican',
        :password            => 'barbican_password',
        :email               => 'alt_barbican@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
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
