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
# Unit tests for barbican_api_paste_ini type class
#
require 'puppet'
require 'puppet/type/barbican_api_paste_ini'

describe 'Puppet::Type.type(:barbican_api_paste_ini)' do
  before :each do
    Puppet::Type.rmtype(:barbican_api_paste_ini)
    Facter.fact(:osfamily).stubs(:value).returns(platform_params[:osfamily])
    @barbican_api_paste_ini = Puppet::Type.type(:barbican_api_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  shared_examples_for 'barbican_api_paste_ini' do

    it 'should require a name' do
      expect {
        Puppet::Type.type(:barbican_api_paste_ini).new({})
      }.to raise_error(Puppet::Error, 'Title or name must be provided')
    end

    it 'should not expect a name with whitespace' do
      expect {
        Puppet::Type.type(:barbican_api_paste_ini).new(:name => 'f oo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should fail when there is no section' do
      expect {
        Puppet::Type.type(:barbican_api_paste_ini).new(:name => 'foo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should not require a value when ensure is absent' do
      Puppet::Type.type(:barbican_api_paste_ini).new(:name => 'DEFAULT/foo', :ensure => :absent)
    end

    it 'should accept a valid value' do
      @barbican_api_paste_ini[:value] = 'bar'
      expect(@barbican_api_paste_ini[:value]).to eq('bar')
    end

    it 'should not accept a value with whitespace' do
      @barbican_api_paste_ini[:value] = 'b ar'
      expect(@barbican_api_paste_ini[:value]).to eq('b ar')
    end

    it 'should accept valid ensure values' do
      @barbican_api_paste_ini[:ensure] = :present
      expect(@barbican_api_paste_ini[:ensure]).to eq(:present)
      @barbican_api_paste_ini[:ensure] = :absent
      expect(@barbican_api_paste_ini[:ensure]).to eq(:absent)
    end

    it 'should not accept invalid ensure values' do
      expect {
        @barbican_api_paste_ini[:ensure] = :latest
      }.to raise_error(Puppet::Error, /Invalid value/)
    end

    it 'should autorequire the package that install the file' do
      catalog = Puppet::Resource::Catalog.new
      package = Puppet::Type.type(:package).new(:name => platform_params[:package_name])
      catalog.add_resource package, @barbican_api_paste_ini
      dependency = @barbican_api_paste_ini.autorequire
      expect(dependency.size).to eq(1)
      expect(dependency[0].target).to eq(@barbican_api_paste_ini)
      expect(dependency[0].source).to eq(package)
    end
  end

  context 'on RedHat platforms' do
    let :platform_params do
      { :package_name => 'openstack-barbican-api',
        :osfamily     => 'RedHat'}
    end

    it_behaves_like 'barbican_api_paste_ini'
  end

end

