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
# Unit tests for barbican::keystone::notification class
#
require 'spec_helper'

describe 'barbican::keystone::notification' do

  shared_examples_for 'barbican keystone notification' do

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

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :processorcount => 8,
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      it_configures 'barbican keystone notification'
    end
  end
end
