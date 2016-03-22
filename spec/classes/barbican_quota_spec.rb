require 'spec_helper'

describe 'barbican::quota' do

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
      :quota_secrets                      => '<SERVICE DEFAULT>',
      :quota_orders                       => '<SERVICE DEFAULT>',
      :quota_containers                   => '<SERVICE DEFAULT>',
      :quota_consumers                    => '<SERVICE DEFAULT>',
      :quota_cas                          => '<SERVICE DEFAULT>',
    }
  end

  [{},
   {
      :quota_secrets                      => 100,
      :quota_orders                       => 100,
      :quota_containers                   => 100,
      :quota_consumers                    => 100,
      :quota_cas                          => 10,
    }
  ].each do |param_set|

    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it 'is_expected.to set quota parameters' do
        [
          'quota_secrets',
          'quota_orders',
          'quota_containers',
          'quota_consumers',
          'quota_cas',
        ].each do |config|
          is_expected.to contain_barbican_config("quotas/#{config}").with_value(param_hash[config.intern])
        end
      end
    end
  end
end
