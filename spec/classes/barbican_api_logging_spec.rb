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
# Unit tests for barbican::api::logging class
#
require 'spec_helper'

describe 'barbican::api::logging' do

  let :params do
    {
    }
  end

  let :log_params do
    {
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append => '/etc/barbican/logging.conf',
      :publish_errors => true,
      :default_log_levels => {
        'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
        'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
        'requests.packages.urllib3.connectionpool' => 'WARN' },
     :fatal_deprecations => true,
     :instance_format => '[instance: %(uuid)s] ',
     :instance_uuid_format => '[instance: %(uuid)s] ',
     :log_date_format => '%Y-%m-%d %H:%M:%S',
    }
  end

  shared_examples_for 'barbican-logging' do

    context 'with extended logging options' do
      before { params.merge!( log_params ) }
      it_configures 'logging params set'
    end

    context 'without extended logging options' do
      it_configures 'logging params unset'
    end

  end

  shared_examples_for 'logging params set' do
    it 'enables logging params' do
      is_expected.to contain_barbican_config('DEFAULT/logging_context_format_string').with_value(
        '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s')

      is_expected.to contain_barbican_config('DEFAULT/logging_default_format_string').with_value(
        '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s')

      is_expected.to contain_barbican_config('DEFAULT/logging_debug_format_suffix').with_value(
        '%(funcName)s %(pathname)s:%(lineno)d')

      is_expected.to contain_barbican_config('DEFAULT/logging_exception_prefix').with_value(
       '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s')

      is_expected.to contain_barbican_config('DEFAULT/log_config_append').with_value(
        '/etc/barbican/logging.conf')
      is_expected.to contain_barbican_config('DEFAULT/publish_errors').with_value(
        true)

      is_expected.to contain_barbican_config('DEFAULT/default_log_levels').with_value(
        'amqp=WARN,amqplib=WARN,boto=WARN,iso8601=WARN,requests.packages.urllib3.connectionpool=WARN,sqlalchemy=WARN,suds=INFO')

      is_expected.to contain_barbican_config('DEFAULT/fatal_deprecations').with_value(
        true)

      is_expected.to contain_barbican_config('DEFAULT/instance_format').with_value(
        '[instance: %(uuid)s] ')

      is_expected.to contain_barbican_config('DEFAULT/instance_uuid_format').with_value(
        '[instance: %(uuid)s] ')

      is_expected.to contain_barbican_config('DEFAULT/log_date_format').with_value(
        '%Y-%m-%d %H:%M:%S')
    end
  end


  shared_examples_for 'logging params unset' do
   [ :logging_context_format_string, :logging_default_format_string,
     :logging_debug_format_suffix, :logging_exception_prefix,
     :log_config_append, :publish_errors,
     :default_log_levels, :fatal_deprecations,
     :instance_format, :instance_uuid_format,
     :log_date_format, ].each { |param|
        it { is_expected.to contain_barbican_config("DEFAULT/#{param}").with_value('<SERVICE DEFAULT>') }
      }
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

      it_configures 'barbican-logging'
    end
  end

end
