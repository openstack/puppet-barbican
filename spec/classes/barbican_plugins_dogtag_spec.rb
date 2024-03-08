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
# Unit tests for barbican::plugins::dogtag class
#
require 'spec_helper'

describe 'barbican::plugins::dogtag' do
  let :default_params do
    {
      :dogtag_plugin_ensure_package => 'present',
      :dogtag_plugin_pem_path       => '<SERVICE DEFAULT>',
      :dogtag_plugin_dogtag_host    => '<SERVICE DEFAULT>',
      :dogtag_plugin_dogtag_port    => '<SERVICE DEFAULT>',
      :dogtag_plugin_nss_db_path    => '<SERVICE DEFAULT>',
      :global_default               => false,
    }
  end

  shared_examples 'barbican::plugins::dogtag' do
    [{
       :dogtag_plugin_nss_password => 'password',
     },
     {
       :dogtag_plugin_pem_path     => 'path_to_pem_file',
       :dogtag_plugin_dogtag_host  => 'dogtag_host',
       :dogtag_plugin_dogtag_port  => '1234',
       :dogtag_plugin_nss_db_path  => 'path_to_nss_db',
       :dogtag_plugin_nss_password => 'password',
       :global_default             => true,
      }
    ].each do |param_set|
      context "when #{param_set == {} ? "using default" : "specifying"} class parameters" do
        let :param_hash do
          default_params.merge(param_set)
        end

        let :params do
          param_set
        end

        it { should contain_package('dogtag-client').with(
          :ensure => param_hash[:dogtag_plugin_ensure_package],
          :name   => 'pki-base',
          :tag    => ['openstack', 'barbican-package'],
        )}

        it {
          should contain_barbican_config('dogtag_plugin/pem_path').with_value(param_hash[:dogtag_plugin_pem_path])
          should contain_barbican_config('dogtag_plugin/dogtag_host').with_value(param_hash[:dogtag_plugin_dogtag_host])
          should contain_barbican_config('dogtag_plugin/dogtag_port').with_value(param_hash[:dogtag_plugin_dogtag_port])
          should contain_barbican_config('dogtag_plugin/nss_db_path').with_value(param_hash[:dogtag_plugin_nss_db_path])
          should contain_barbican_config('dogtag_plugin/nss_password').with_value(param_hash[:dogtag_plugin_nss_password]).with_secret(true)
          should contain_barbican_config('secretstore:dogtag/secret_store_plugin').with_value('dogtag_crypto')
          should contain_barbican_config('secretstore:dogtag/global_default').with_value(param_hash[:global_default])
        }
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'barbican::plugins::dogtag'
    end
  end
end
