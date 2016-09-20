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
# Unit tests for barbican::config class
#
require 'spec_helper'

describe 'barbican::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'barbican_config' do
    let :params do
      { :api_config => config_hash }
    end

    it 'configures arbitrary barbican-config configurations' do
      is_expected.to contain_barbican_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_barbican_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_barbican_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'barbican_api_paste_ini' do
    let :params do
      { :api_paste_ini_config => config_hash }
    end

    it 'configures arbitrary barbican-api-paste-ini configurations' do
      is_expected.to contain_barbican_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_barbican_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_barbican_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'barbican_config'
      it_configures 'barbican_api_paste_ini'
    end
  end
end
