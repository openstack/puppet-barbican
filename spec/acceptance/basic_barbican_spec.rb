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
# Acceptance test for barbican::api class
#
require 'spec_helper_acceptance'
describe 'barbican::api basic test class' do
  context 'default parameters' do
    pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone
      include ::barbican

      class { '::barbican::keystone::auth':
         password => 'a_big_secret',
      }

      class { '::barbican::api::logging': }

      class { '::barbican::quota': }

      class { '::barbican::keystone::notification': }

      class { '::barbican::db::mysql':
        password => 'a_big_secret',
      }

      class { '::barbican::db':
        database_connection => 'mysql+pymysql://barbican:a_big_secret@127.0.0.1/barbican?charset=utf8',
      }

      class { '::barbican::keystone::authtoken':
        password => 'a_big_secret',
      }

      class { '::barbican::api':
        host_href                   => 'http://localhost:9311',
        auth_strategy               => 'keystone',
        service_name                => 'httpd',
        enabled_certificate_plugins => ['simple_certificate'],
        db_auto_create              => false,
      }

      include ::apache
      class { '::barbican::wsgi::apache':
        ssl => false,
      }

    EOS

    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    if os[:family].casecmp('RedHat') == 0
      describe 'store a secret' do
        it 'should store a secret' do
          shell('barbican --os-username barbican --os-password a_big_secret --os-tenant-name services --os-auth-url http://127.0.0.1:5000/v2.0 --endpoint http://localhost:9311 secret store --payload "my big bad secret" --os-identity-api-version 2') do |r|
            expect(r.stdout).to match(/ACTIVE/)
          end
        end
      end

      describe 'generate a secret' do
        it 'should generate a secret' do
          shell('barbican --os-username barbican --os-password a_big_secret --os-tenant-name services --os-auth-url http://127.0.0.1:5000/v2.0 --endpoint http://localhost:9311 secret order create key --name foo --os-identity-api-version 2') do |r|
            expect(r.stdout).to match(/Order href/)
          end
        end
      end

      describe port(9311) do
        it { is_expected.to be_listening }
      end
    end
  end
end
