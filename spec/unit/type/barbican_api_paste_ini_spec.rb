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
    @barbican_api_paste_ini = Puppet::Type.type(:barbican_api_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should accept a valid value' do
    @barbican_api_paste_ini[:value] = 'bar'
    expect(@barbican_api_paste_ini[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'barbican::install::end')
    catalog.add_resource anchor, @barbican_api_paste_ini
    dependency = @barbican_api_paste_ini.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@barbican_api_paste_ini)
    expect(dependency[0].source).to eq(anchor)
  end

end

