#
# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
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

require 'spec_helper'

describe 'barbican::worker' do
  let :params do
    {}
  end

  shared_examples 'barbican::worker' do
    context 'with default parameters' do
      it { should contain_package('barbican-worker').with(
        :ensure => 'present',
        :name   => platform_params[:worker_package_name],
        :tag    => ['openstack', 'barbican-package']
      )}

      it { should contain_service('barbican-worker').with(
        :ensure     => 'running',
        :name       => platform_params[:worker_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'barbican-service'
      )}
    end

    context 'with package_ensure set to absent' do
      before do
        params.merge!( :package_ensure => 'absent' )
      end

      it { should contain_package('barbican-worker').with_ensure('absent') }
    end

    context 'with manage_service set to false' do
      before do
        params.merge!( :manage_service => false )
      end

      it { should contain_package('barbican-worker').with_ensure('present') }
      it { should_not contain_service('barbican-worker') }
    end

    context 'with enabled set to false' do
      before do
        params.merge!( :enabled => false )
      end

      it { should contain_package('barbican-worker').with_ensure('present') }
      it { should contain_service('barbican-worker').with_enable(false) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      case facts[:os]['family']
      when 'RedHat'
        let (:platform_params) do
          {
            :worker_package_name => 'openstack-barbican-worker',
            :worker_service_name => 'openstack-barbican-worker'
          }
        end
      when 'Debian'
        let (:platform_params) do
          {
            :worker_package_name => 'barbican-worker',
            :worker_service_name => 'barbican-worker'
          }
        end
      end

      it_behaves_like 'barbican::worker'
    end
  end
end
