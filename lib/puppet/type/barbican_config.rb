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
Puppet::Type.newtype(:barbican_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from barbican.conf'
    newvalues(/\S+\/\S+/)
  end

  newproperty(:value, :array_matching => :all) do
    desc 'The value of the setting to be defined.'
    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end
    newvalues(/^[\S ]*$/)

    def is_to_s( currentvalue )
      if resource.secret?
        return '[old secret redacted]'
      else
        return currentvalue
      end
    end

    def should_to_s( newvalue )
      if resource.secret?
        return '[new secret redacted]'
      else
        return newvalue
      end
    end

    def insync?(is)
      return true if @should.empty?
      return false unless is.is_a? Array
      return false unless is.length == @should.length
      # we don't care about the order of items in array, hence
      # it is necessary to override insync
      return (
        is & @should == is or
        is & @should.map(&:to_s) == is
      )
    end
  end

  newparam(:secret, :boolean => true) do
    desc 'Whether to hide the value from Puppet logs. Defaults to `false`.'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:ensure_absent_val) do
    desc 'A value that is specified as the value property will behave as if ensure => absent was specified'
    defaultto('<SERVICE DEFAULT>')
  end

  autorequire(:anchor) do
    ['barbican::install::end']
  end

end
