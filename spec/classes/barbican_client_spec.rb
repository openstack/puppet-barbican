require 'spec_helper'

describe 'barbican::client' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
      }
    )
  end

  describe "with default parameters" do
    it { is_expected.to contain_package('python-barbicanclient').with(
        'ensure' => 'present',
        'tag'    => 'openstack'
    ) }
    it { is_expected.to contain_package('python-openstackclient').with(
        'ensure' => 'present',
        'tag'    => 'openstack',
    ) }
  end

  describe "with specified version" do
    let :params do
      {:ensure => '2013.1'}
    end

    it { is_expected.to contain_package('python-barbicanclient').with(
        'ensure' => '2013.1',
        'tag'    => 'openstack'
    ) }
  end
end
