require 'spec_helper'

describe 'barbican::keystone::notification' do

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
      :enable_keystone_notification                  => '<SERVICE DEFAULT>',
      :keystone_notification_control_exchange        => '<SERVICE DEFAULT>',
      :keystone_notification_topic                   => '<SERVICE DEFAULT>',
      :keystone_notification_allow_requeue           => '<SERVICE DEFAULT>',
      :keystone_notification_thread_pool_size        => '<SERVICE DEFAULT>',
    }
  end

  [{},
   {
      :enable_keystone_notification                  => true,
      :keystone_notification_control_exchange        => 'exchange_data',
      :keystone_notification_topic                   => 'barbican',
      :keystone_notification_allow_requeue           => true,
      :keystone_notification_thread_pool_size        => 20,
   }
  ].each do |param_set|

    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      it 'is_expected.to set keystone notification parameters' do
        is_expected.to contain_barbican_config('keystone_notifications/enable')\
          .with_value(param_hash[:enable_keystone_notification])
        is_expected.to contain_barbican_config('keystone_notifications/allow_requeue')\
          .with_value(param_hash[:keystone_notification_allow_requeue])
        is_expected.to contain_barbican_config('keystone_notifications/thread_pool_size')\
          .with_value(param_hash[:keystone_notification_thread_pool_size])
        is_expected.to contain_barbican_config('keystone_notifications/topic')\
          .with_value(param_hash[:keystone_notification_topic])
        is_expected.to contain_barbican_config('keystone_notifications/control_exchange')\
          .with_value(param_hash[:keystone_notification_control_exchange])
      end
    end
  end
end
