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
# Unit tests for barbican::plugins::kmip class
#
require 'spec_helper'

describe 'barbican::plugins::kmip' do

  shared_examples_for 'barbican plugins kmip' do

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

      it_configures 'barbican plugins kmip'
    end
  end
end

