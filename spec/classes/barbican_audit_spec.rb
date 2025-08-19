require 'spec_helper'

describe 'barbican::audit' do

  shared_examples_for 'barbican::audit' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_oslo__audit('barbican_config').with(
          :audit_map_file  => '<SERVICE DEFAULT>',
          :ignore_req_list => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :audit_map_file  => '/etc/barbican/api_audit_map.conf',
          :ignore_req_list => ['GET', 'POST'],
        }
      end

      it 'configures specified values' do
        is_expected.to contain_oslo__audit('barbican_config').with(
          :audit_map_file  => '/etc/barbican/api_audit_map.conf',
          :ignore_req_list => ['GET', 'POST'],
        )
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

      it_configures 'barbican::audit'
    end
  end

end
