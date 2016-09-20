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
# Unit tests for barbican::plugins::simple_crypto class
#
require 'spec_helper'

describe 'barbican::plugins::simple_crypto' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  describe 'with parameter passed into pk11 plugin' do
    let :params do
      {
        :simple_crypto_plugin_kek       => 'XXXXXXXXXXXXX'
      }
    end

    it 'is_expected.to set simple_crypto parameters' do
      is_expected.to contain_barbican_config('simple_crypto_plugin/kek') \
        .with_value(params[:simple_crypto_plugin_kek])
    end
  end

  describe 'with no parameter passed into pk11 plugin' do
    let :params do
      {}
    end

    it 'is_expected.to set default simple_crypto parameters' do
      is_expected.to contain_barbican_config('simple_crypto_plugin/kek') \
        .with_value('<SERVICE DEFAULT>')
    end
  end
end
