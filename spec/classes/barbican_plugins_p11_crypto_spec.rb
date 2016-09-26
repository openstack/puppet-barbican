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
# Unit tests for barbican::plugins::p11_crypto class
#
require 'spec_helper'

describe 'barbican::plugins::p11_crypto' do

  shared_examples_for 'barbican plugins p11_crypto' do
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

      it_configures 'barbican plugins p11_crypto'
    end
  end
end
