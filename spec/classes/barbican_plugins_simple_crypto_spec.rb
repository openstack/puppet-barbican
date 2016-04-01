require 'spec_helper'

describe 'barbican::plugins::simple_crypto' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  describe 'with parameter passed into pk11 plugin' do
    let :params do
      {
        :simple_crypto_plugin_kek       => 'XXXXXXXXXXXXX'
      }
    end

    it 'is_expected.to set simple_crypto parameters' do
      is_expected.to contain_barbican_config('simple_crypto_plugin/kek') \
        .with_value(params[:simple_crypto_plugin_kek])
    end
  end

  describe 'with no parameter passed into pk11 plugin' do
    let :params do
      {}
    end

    it 'is_expected.to set default simple_crypto parameters' do
      is_expected.to contain_barbican_config('simple_crypto_plugin/kek') \
        .with_value('<SERVICE DEFAULT>')
    end
  end
end
