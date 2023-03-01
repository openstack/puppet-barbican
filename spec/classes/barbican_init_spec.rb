require 'spec_helper'

describe 'barbican' do

  shared_examples 'barbican' do

    it { is_expected.to contain_class('barbican::deps') }

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'installs packages' do
        is_expected.to contain_package('barbican').with(
          :name   => platform_params[:barbican_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'barbican-package']
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('barbican_config').with({
          :purge => false
        })
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :barbican_common_package => 'barbican-common' }
        when 'RedHat'
          { :barbican_common_package => 'openstack-barbican-common' }
        end
      end
      it_behaves_like 'barbican'
    end
  end
end
