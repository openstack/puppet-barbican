require 'spec_helper'

describe 'barbican::policy' do

  shared_examples_for 'barbican policies' do
    let :params do
      {
        :policy_path => '/etc/barbican/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key   => 'context_is_admin',
        :value => 'foo:bar'
      })
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'barbican policies'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'barbican policies'
  end
end
