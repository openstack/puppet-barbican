require 'spec_helper'

describe 'barbican::plugins::kmip' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  describe 'with kmip plugin with username' do
    let :params do
      {
        :kmip_plugin_username      => 'kmip_user',
        :kmip_plugin_password      => 'kmip_password',
        :kmip_plugin_host          => 'kmip_host',
        :kmip_plugin_port          => 9000,
      }
    end

    it 'is_expected.to set kmip parameters' do
      is_expected.to contain_barbican_config('kmip_plugin/host')\
        .with_value(params[:kmip_plugin_host])
      is_expected.to contain_barbican_config('kmip_plugin/port')\
        .with_value(params[:kmip_plugin_port])
      is_expected.to contain_barbican_config('kmip_plugin/username')\
        .with_value(params[:kmip_plugin_username])
      is_expected.to contain_barbican_config('kmip_plugin/password')\
        .with_value(params[:kmip_plugin_password])
    end
  end

  describe 'with kmip plugin with certificate' do
    let :params do
      {
        :kmip_plugin_keyfile       => 'key_file',
        :kmip_plugin_certfile      => 'cert_file',
        :kmip_plugin_ca_certs      => 'ca_cert_file',
        :kmip_plugin_host          => 'kmip_host',
        :kmip_plugin_port          => 9000,
      }
    end

    it 'is_expected.to set kmip parameters' do
      is_expected.to contain_barbican_config('kmip_plugin/keyfile')\
        .with_value(params[:kmip_plugin_keyfile])
      is_expected.to contain_barbican_config('kmip_plugin/certfile')\
        .with_value(params[:kmip_plugin_certfile])
      is_expected.to contain_barbican_config('kmip_plugin/ca_certs')\
        .with_value(params[:kmip_plugin_ca_certs])
      is_expected.to contain_barbican_config('kmip_plugin/host')\
        .with_value(params[:kmip_plugin_host])
      is_expected.to contain_barbican_config('kmip_plugin/port')\
        .with_value(params[:kmip_plugin_port])
    end
  end
end

