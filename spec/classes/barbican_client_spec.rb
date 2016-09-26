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
# Unit tests for barbican::client class
#
require 'spec_helper'

describe 'barbican::client' do

  shared_examples_for 'barbican client' do
    describe "with default parameters" do
      it { is_expected.to contain_package('python-barbicanclient').with(
        'ensure' => 'present',
        'tag'    => 'openstack'
      )}
      it { is_expected.to contain_package('python-openstackclient').with(
        'ensure' => 'present',
        'tag'    => 'openstack',
      )}
    end

    describe "with specified version" do
      let :params do
        { :ensure => '2013.1' }
      end

      it { is_expected.to contain_package('python-barbicanclient').with(
        'ensure' => '2013.1',
        'tag'    => 'openstack'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :fqdn           => 'some.host.tld',
        }))
      end

      it_configures 'barbican client'
    end
  end
end
