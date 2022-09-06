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
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::mysql
      include openstack_integration::memcached
      include openstack_integration::keystone
      include openstack_integration::barbican
    EOS

    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe 'store a secret' do
      it 'should store a secret' do
        command('barbican --os-username barbican --os-password a_big_secret --os-project-name services --os-user-domain-name Default --os-project-domain-name Default --os-auth-url http://127.0.0.1:5000/v3 --endpoint http://localhost:9311 secret store --payload "my big bad secret" --os-identity-api-version 3') do |r|
          expect(r.stdout).to match(/ACTIVE/)
        end
      end
    end

    describe 'generate a secret' do
      it 'should generate a secret' do
        command('barbican --os-username barbican --os-password a_big_secret --os-project-name services --os-user-domain-name Default --os-project-domain-name Default --os-auth-url http://127.0.0.1:5000/v3 --endpoint http://localhost:9311 secret order create key --name foo --os-identity-api-version 3') do |r|
          expect(r.stdout).to match(/Order href/)
        end
      end
    end

    describe port(9311) do
      it { is_expected.to be_listening }
    end
  end
end
