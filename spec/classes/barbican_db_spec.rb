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

      it { is_expected.to contain_barbican_config('database/connection').with_value('sqlite:////var/lib/barbican/barbican.sqlite') }
      it { is_expected.to contain_barbican_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('database/db_max_retries').with_value('<SERVICE DEFAULT>') }

      # TODO(aschultz): remove once oslo is properly used
      it { is_expected.to contain_barbican_config('DEFAULT/sql_connection').with_value('sqlite:////var/lib/barbican/barbican.sqlite') }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_pool_max_overflow').with_value('<SERVICE DEFAULT>') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://barbican:barbican@localhost/barbican',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_overflow   => '11',
          :database_pool_size      => '2',
          :database_db_max_retries => '-1',
        }
      end

      it { is_expected.to contain_barbican_config('database/connection').with_value('mysql+pymysql://barbican:barbican@localhost/barbican').with_secret(true) }
      it { is_expected.to contain_barbican_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_barbican_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_barbican_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_barbican_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_barbican_config('database/max_overflow').with_value('11') }
      it { is_expected.to contain_barbican_config('database/db_max_retries').with_value('-1') }

      # TODO(aschultz) remove once oslo is properly used
      it { is_expected.to contain_barbican_config('DEFAULT/sql_connection').with_value('mysql+pymysql://barbican:barbican@localhost/barbican').with_secret(true) }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_idle_timeout').with_value('3601') }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_pool_size').with_value('2') }
      it { is_expected.to contain_barbican_config('DEFAULT/sql_pool_max_overflow').with_value('11') }
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://barbican:barbican@localhost/barbican', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end
    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://barbican:barbican@localhost/barbican', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://barbican:barbican@localhost/barbican', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://barbican:barbican@localhost/barbican', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      })
    end

    it_configures 'barbican::db'

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/barbican/barbican.sqlite', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => 'openstack'
        )
      end

    end

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://barbican:barbican@localhost/barbican', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('db_backend_package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end

  end

  shared_examples_for 'barbican db on redhat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql://barbican:barbican@localhost/barbican', }
      end

      it { is_expected.not_to contain_package('db_backend_package') }
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

      it_configures 'barbican::db'

      case facts[:osfamily]
      when 'RedHat'
        it_configures 'barbican db on redhat'
      end
    end
  end

end

