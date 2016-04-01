require 'spec_helper'

describe 'barbican::plugins::p11_crypto' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  describe 'with pk11 plugin' do
    let :params do
      {
        :p11_crypto_plugin_login        => 'p11_user',
        :p11_crypto_plugin_mkek_label   => 'mkek_label',
        :p11_crypto_plugin_mkek_length  => 32,
        :p11_crypto_plugin_hmac_label   => 'hmac_label',
        :p11_crypto_plugin_slot_id      => 1,
        :p11_crypto_plugin_library_path => '/usr/lib/libCryptoki2_64.so',
      }
    end

    it 'is_expected.to set p11 parameters' do
      is_expected.to contain_barbican_config('p11_crypto_plugin/login') \
        .with_value(params[:p11_crypto_plugin_login])
      is_expected.to contain_barbican_config('p11_crypto_plugin/mkek_label') \
        .with_value(params[:p11_crypto_plugin_mkek_label])
      is_expected.to contain_barbican_config('p11_crypto_plugin/mkek_length') \
        .with_value(params[:p11_crypto_plugin_mkek_length])
      is_expected.to contain_barbican_config('p11_crypto_plugin/hmac_label') \
        .with_value(params[:p11_crypto_plugin_hmac_label])
      is_expected.to contain_barbican_config('p11_crypto_plugin/slot_id') \
        .with_value(params[:p11_crypto_plugin_slot_id])
      is_expected.to contain_barbican_config('p11_crypto_plugin/library_path') \
        .with_value(params[:p11_crypto_plugin_library_path])
    end
  end
end
