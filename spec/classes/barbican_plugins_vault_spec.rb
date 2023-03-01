#
# Copyright (C) 2019 Matthew J. Black
#
# Author: Matthew J. Black <mjblack@gmail.com>
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
# Unit tests for barbican::plugins::vault class
#
require 'spec_helper'

describe 'barbican::plugins::vault' do

  shared_examples_for 'barbican plugins vault' do
    describe 'with minimal parameters passed into vault plugin' do
      let :params do
        {
          :vault_url       => 'http://127.0.0.1:8200',
          :root_token_id   => 'barbican_root_token_id',
          :global_default  => true,
        }
      end

      it 'is_expected.to set vault plugin parameters' do
        is_expected.to contain_barbican_config('vault_plugin/vault_url') \
          .with_value(params[:vault_url])
        is_expected.to contain_barbican_config(
          'secretstore:vault/secret_store_plugin') \
          .with_value('vault_plugin')
        is_expected.to contain_barbican_config(
          'secretstore:vault/global_default') \
          .with_value('true')
      end
    end

    describe 'with approle parameters passed into vault plugin' do
      let :params do
        {
          :vault_url         => 'https://127.0.0.1:8200',
          :use_ssl           => true,
          :approle_role_id   => 'barbican_approle_role_id',
          :approle_secret_id => 'barbican_approle_secret_id',
          :kv_mountpoint     => 'barbican_secrets',
        }
      end

      it 'is_expected.to set vault plugin parameters' do
        is_expected.to contain_barbican_config('vault_plugin/vault_url') \
          .with_value(params[:vault_url])
        is_expected.to contain_barbican_config('vault_plugin/use_ssl') \
          .with_value(params[:use_ssl])
        is_expected.to contain_barbican_config('vault_plugin/approle_role_id') \
          .with_value(params[:approle_role_id])
        is_expected.to contain_barbican_config('vault_plugin/approle_secret_id') \
          .with_value(params[:approle_secret_id])
        is_expected.to contain_barbican_config('vault_plugin/kv_mountpoint') \
          .with_value(params[:kv_mountpoint])
        is_expected.to contain_barbican_config(
          'secretstore:vault/secret_store_plugin') \
          .with_value('vault_plugin')
        is_expected.to contain_barbican_config(
          'secretstore:vault/global_default') \
          .with_value('false')
      end
    end

    describe 'with no parameter passed into vault plugin' do
      let :params do
        {}
      end

      it 'is_expected.to set default vault parameters' do
        is_expected.to contain_barbican_config('vault_plugin/vault_url') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('vault_plugin/root_token_id') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('vault_plugin/approle_role_id') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('vault_plugin/approle_secret_id') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('vault_plugin/kv_mountpoint') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('vault_plugin/use_ssl') \
          .with_value('false')
        is_expected.to contain_barbican_config('vault_plugin/ssl_ca_crt_file') \
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config(
          'secretstore:vault/secret_store_plugin') \
          .with_value('vault_plugin')
        is_expected.to contain_barbican_config(
          'secretstore:vault/global_default') \
          .with_value('false')
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

      it_configures 'barbican plugins vault'
    end
  end
end
