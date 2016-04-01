require 'spec_helper'

describe 'barbican::plugins::dogtag' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  let :default_params do
    {
      :dogtag_plugin_ensure_package       => 'present',
      :dogtag_plugin_pem_path             => '<SERVICE DEFAULT>',
      :dogtag_plugin_dogtag_host          => '<SERVICE DEFAULT>',
      :dogtag_plugin_dogtag_port          => '<SERVICE DEFAULT>',
      :dogtag_plugin_nss_db_path          => '<SERVICE DEFAULT>',
      :dogtag_plugin_simple_cmc_profile   => '<SERVICE DEFAULT>',
      :dogtag_plugin_ca_expiration_time   => '<SERVICE DEFAULT>',
      :dogtag_plugin_plugin_working_dir   => '<SERVICE DEFAULT>',
    }
  end

  [{
      :dogtag_plugin_nss_password         => 'password',
   },
   {
      :dogtag_plugin_pem_path             => 'path_to_pem_file',
      :dogtag_plugin_dogtag_host          => 'dogtag_host',
      :dogtag_plugin_dogtag_port          => '1234',
      :dogtag_plugin_nss_db_path          => 'path_to_nss_db',
      :dogtag_plugin_nss_password         => 'password',
      :dogtag_plugin_simple_cmc_profile   => 'caServerCert',
      :dogtag_plugin_ca_expiration_time   => '100',
      :dogtag_plugin_plugin_working_dir   => 'path_to_working_dir',
    }
  ].each do |param_set|

    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it { is_expected.to contain_package('python-barbicanclient').with(
        'ensure' => param_hash[:dogtag_plugin_ensure_package],
        'tag'    => 'openstack',
      ) }

      it 'is_expected.to set dogtag parameters' do
        is_expected.to contain_barbican_config('dogtag_plugin/pem_path')\
          .with_value(param_hash[:dogtag_plugin_pem_path])
        is_expected.to contain_barbican_config('dogtag_plugin/dogtag_host')\
          .with_value(param_hash[:dogtag_plugin_dogtag_host])
        is_expected.to contain_barbican_config('dogtag_plugin/dogtag_port')\
          .with_value(param_hash[:dogtag_plugin_dogtag_port])
        is_expected.to contain_barbican_config('dogtag_plugin/nss_db_path')\
          .with_value(param_hash[:dogtag_plugin_nss_db_path])
        is_expected.to contain_barbican_config('dogtag_plugin/nss_password')\
          .with_value(param_hash[:dogtag_plugin_nss_password])
        is_expected.to contain_barbican_config('dogtag_plugin/simple_cmc_profile')\
          .with_value(param_hash[:dogtag_plugin_simple_cmc_profile])
        is_expected.to contain_barbican_config('dogtag_plugin/ca_expiration_time')\
          .with_value(param_hash[:dogtag_plugin_ca_expiration_time])
        is_expected.to contain_barbican_config('dogtag_plugin/plugin_working_dir')\
          .with_value(param_hash[:dogtag_plugin_plugin_working_dir])
      end
    end
  end
end

