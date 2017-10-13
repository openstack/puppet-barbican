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
    context 'with default parameters' do
      it { is_expected.to contain_class('barbican::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('barbican_wsgi_main').with(
        :bind_port           => 9311,
        :group               => 'barbican',
        :path                => '/',
        :servername          => facts[:fqdn],
        :ssl                 => true,
        :threads             => 1,
        :user                => 'barbican',
        :workers             => facts[:os_workers],
        :wsgi_daemon_process => 'barbican-api',
        :wsgi_process_group  => 'barbican-api',
        :wsgi_script_dir     => platform_params[:wsgi_script_path],
        :wsgi_script_file    => 'main',
        :wsgi_script_source  => platform_params[:wsgi_script_source],
        :access_log_file     => false,
        :access_log_format   => false,
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :public_port               => 12345,
          :ssl                       => false,
          :wsgi_process_display_name => 'barbican-api',
          :workers                   => 37,
          :access_log_file           => '/var/log/httpd/access_log',
          :access_log_format         => 'some format',
          :error_log_file            => '/var/log/httpd/error_log'
        }
      end
      it { is_expected.to contain_class('barbican::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('barbican_wsgi_main').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'barbican',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => false,
        :threads                   => 1,
        :user                      => 'barbican',
        :workers                   => 37,
        :wsgi_daemon_process       => 'barbican-api',
        :wsgi_process_display_name => 'barbican-api',
        :wsgi_process_group        => 'barbican-api',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'main',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
  }).each do |os,facts|
    let (:facts) do
      facts.merge!(OSDefaults.get_facts({
        :os_workers     => 8,
        :concat_basedir => '/var/lib/puppet/concat',
        :fqdn           => 'some.host.tld'
      }))
    end

    let(:platform_params) do
      case facts[:osfamily]
      when 'Debian'
        {
          :httpd_service_name => 'apache2',
          :httpd_ports_file   => '/etc/apache2/ports.conf',
          :wsgi_script_path   => '/usr/lib/cgi-bin/barbican',
          :wsgi_script_source => '/usr/lib/python2.7/dist-packages/barbican/api/app.wsgi',
          :httpd_config_file  => '/etc/apache2/conf-available/barbican-api.conf',
        }
      when 'RedHat'
        {
          :httpd_service_name => 'httpd',
          :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
          :wsgi_script_path   => '/var/www/cgi-bin/barbican',
          :wsgi_script_source => '/usr/lib/python2.7/site-packages/barbican/api/app.wsgi',
          :httpd_config_file  => '/etc/httpd/conf.d/barbican-api.conf',
        }
      end
    end

    it_behaves_like 'apache serving barbican with mod_wsgi'
  end
end
