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
# Unit tests for barbican::quota class
#
require 'spec_helper'

describe 'barbican::quota' do

  shared_examples_for 'barbican quota' do
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

      it_configures 'barbican quota'
    end
  end
end
