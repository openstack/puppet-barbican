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
# Unit tests for barbican::db class
#
require 'spec_helper'

describe 'barbican::db' do
  shared_examples 'barbican::db' do
    context 'with default parameters' do
      it { should contain_class('barbican::deps') }

      it { should contain_oslo__db('barbican_config').with(
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection              => 'sqlite:////var/lib/barbican/barbican.sqlite',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :mysql_enable_ndb        => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection              => 'mysql+pymysql://barbican:barbican@localhost/barbican',
          :database_connection_recycle_time => '3601',
          :database_max_pool_size           => '11',
          :database_max_retries             => '11',
          :database_retry_interval          => '11',
          :database_max_overflow            => '11',
          :database_pool_timeout            => '11',
          :mysql_enable_ndb                 => true,
          :database_pool_size               => '2',
          :database_db_max_retries          => '-1',
        }
      end

      it { should contain_class('barbican::deps') }

      it { should contain_oslo__db('barbican_config').with(
        :db_max_retries          => '-1',
        :connection              => 'mysql+pymysql://barbican:barbican@localhost/barbican',
        :connection_recycle_time => '3601',
        :max_pool_size           => '11',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '11',
        :pool_timeout            => '11',
        :mysql_enable_ndb        => true,
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'barbican::db'
    end
  end
end
