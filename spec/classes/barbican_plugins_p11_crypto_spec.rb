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
          :p11_crypto_plugin_login                     => 'p11_user',
          :p11_crypto_plugin_mkek_label                => 'mkek_label',
          :p11_crypto_plugin_mkek_length               => 32,
          :p11_crypto_plugin_hmac_label                => 'hmac_label',
          :p11_crypto_plugin_token_serial_number       => 'token_serial',
          :p11_crypto_plugin_token_labels              => 'token_label1,token_label2',
          :p11_crypto_plugin_slot_id                   => 1,
          :p11_crypto_plugin_library_path              => '/usr/lib/libCryptoki2_64.so',
          :p11_crypto_plugin_encryption_mechanism      => 'CKM_AES_CBC',
          :p11_crypto_plugin_hmac_key_type             => 'CKK_AES',
          :p11_crypto_plugin_hmac_keygen_mechanism     => 'CKM_AES_KEY_GEN',
          :p11_crypto_plugin_aes_gcm_generate_iv       => false,
          :p11_crypto_plugin_os_locking_ok             => false,
          :p11_crypto_plugin_always_set_cka_sensitive  => true,
          :global_default                              => true,
        }
      end

      it 'is_expected.to set p11 parameters' do
        is_expected.to contain_barbican_config('p11_crypto_plugin/login') \
          .with_value(params[:p11_crypto_plugin_login]).with_secret(true)
        is_expected.to contain_barbican_config('p11_crypto_plugin/mkek_label') \
          .with_value(params[:p11_crypto_plugin_mkek_label])
        is_expected.to contain_barbican_config('p11_crypto_plugin/mkek_length') \
          .with_value(params[:p11_crypto_plugin_mkek_length])
        is_expected.to contain_barbican_config('p11_crypto_plugin/hmac_label') \
          .with_value(params[:p11_crypto_plugin_hmac_label])
        is_expected.to contain_barbican_config('p11_crypto_plugin/token_serial_number') \
          .with_value(params[:p11_crypto_plugin_token_serial_number])
        is_expected.to contain_barbican_config('p11_crypto_plugin/token_labels') \
          .with_value(params[:p11_crypto_plugin_token_labels])
        is_expected.to contain_barbican_config('p11_crypto_plugin/slot_id') \
          .with_value(params[:p11_crypto_plugin_slot_id])
        is_expected.to contain_barbican_config('p11_crypto_plugin/library_path') \
          .with_value(params[:p11_crypto_plugin_library_path])
        is_expected.to contain_barbican_config('p11_crypto_plugin/encryption_mechanism') \
          .with_value(params[:p11_crypto_plugin_encryption_mechanism])
        is_expected.to contain_barbican_config('p11_crypto_plugin/hmac_key_type') \
          .with_value(params[:p11_crypto_plugin_hmac_key_type])
        is_expected.to contain_barbican_config('p11_crypto_plugin/hmac_keygen_mechanism') \
          .with_value(params[:p11_crypto_plugin_hmac_keygen_mechanism])
        is_expected.to contain_barbican_config('p11_crypto_plugin/aes_gcm_generate_iv') \
          .with_value(params[:p11_crypto_plugin_aes_gcm_generate_iv])
        is_expected.to contain_barbican_config('p11_crypto_plugin/always_set_cka_sensitive') \
          .with_value(params[:p11_crypto_plugin_always_set_cka_sensitive])
        is_expected.to contain_barbican_config('p11_crypto_plugin/os_locking_ok') \
          .with_value(params[:p11_crypto_plugin_os_locking_ok])
        is_expected.to contain_barbican_config(
          'secretstore:pkcs11/secret_store_plugin') \
          .with_value('store_crypto')
        is_expected.to contain_barbican_config(
          'secretstore:pkcs11/crypto_plugin') \
          .with_value('p11_crypto')
        is_expected.to contain_barbican_config(
          'secretstore:pkcs11/global_default') \
          .with_value('true')
      end

      context 'when p11_crypto_plugin_token_labels is a list' do
        before do
          params.merge!( :p11_crypto_plugin_token_labels => ['token_label1', 'token_label2'] )
        end

        it 'is_expected.to set p11 parameters' do
          is_expected.to contain_barbican_config('p11_crypto_plugin/token_labels') \
            .with_value('token_label1,token_label2')
        end
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'barbican plugins p11_crypto'
    end
  end
end
