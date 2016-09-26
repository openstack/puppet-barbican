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
# Unit tests for barbican::wsgi::apache class
#
require 'spec_helper'

describe 'barbican::wsgi::apache' do

  shared_examples_for 'apache serving barbican with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_parameters[:httpd_service_name]) }
    it { is_expected.to contain_class('barbican::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      it { is_expected.to contain_file("#{platform_parameters[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'barbican',
        'group'   => 'barbican',
        'require' => 'Package[httpd]',
      )}

      it { is_expected.to contain_file('barbican_wsgi_main').with(
        'ensure'  => 'file',
        'path'    => "#{platform_parameters[:wsgi_script_path]}/main",
        'owner'   => 'barbican',
        'group'   => 'barbican',
        'mode'    => '0644',
        'require' => [ "File[#{platform_parameters[:wsgi_script_path]}]", "Package[barbican-api]" ],
      )}

      it { is_expected.to contain_apache__vhost('barbican_wsgi_main').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '9311',
        'docroot'                     => "#{platform_parameters[:wsgi_script_path]}",
        'docroot_owner'               => 'barbican',
        'docroot_group'               => 'barbican',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'barbican-api',
        'wsgi_daemon_process_options' => {
          'user'         => 'barbican',
          'group'        => 'barbican',
          'processes'    => '1',
          'threads'      => '42',
          'display-name' => 'barbican-api',
        },
        'wsgi_process_group'          => 'barbican-api',
        'wsgi_script_aliases'         => { '/' => "#{platform_parameters[:wsgi_script_path]}/main" },
        'wsgi_application_group'      => '%{GLOBAL}',
        'wsgi_pass_authorization'     => 'On',
        'headers'                     => nil,
        'require'                     => 'File[barbican_wsgi_main]',
        'access_log_format'           => false,
      )}
      it { is_expected.to contain_concat("#{platform_parameters[:httpd_ports_file]}") }
    end

    describe 'when overriding default apache logging' do
      let :params do
        {
          :servername        => 'dummy.host',
          :access_log_format => 'foo',
        }
      end
      it { is_expected.to contain_apache__vhost('barbican_wsgi_main').with(
          'servername'        => 'dummy.host',
          'access_log_format' => 'foo',
          )}
    end

    describe 'when overriding parameters using symlink and custom file source' do
      let :params do
        {
          :wsgi_script_ensure => 'link',
          :wsgi_script_source => '/opt/barbican/httpd/barbican.py',
        }
      end

      it { is_expected.to contain_file('barbican_wsgi_main').with(
        'ensure'  => 'link',
        'path'    => "#{platform_parameters[:wsgi_script_path]}/main",
        'target'  => '/opt/barbican/httpd/barbican.py',
        'owner'   => 'barbican',
        'group'   => 'barbican',
        'mode'    => '0644',
        'require' => [ "File[#{platform_parameters[:wsgi_script_path]}]", "Package[barbican-api]" ],
      )}
    end
  end

  on_supported_os({
  }).each do |os,facts|
    let (:facts) do
      facts.merge!(OSDefaults.get_facts({
        :processorcount => 42,
        :concat_basedir => '/var/lib/puppet/concat',
        :fqdn           => 'some.host.tld'
      }))
    end

    let(:platform_parameters) do
      case facts[:osfamily]
      when 'Debian'
        {
          :httpd_service_name => 'apache2',
          :httpd_ports_file   => '/etc/apache2/ports.conf',
          :wsgi_script_path   => '/usr/lib/cgi-bin/barbican',
        }
      when 'RedHat'
        {
          :httpd_service_name => 'httpd',
          :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
          :wsgi_script_path   => '/var/www/cgi-bin/barbican',
        }
      end
    end

    it_behaves_like 'apache serving barbican with mod_wsgi'
  end
end
