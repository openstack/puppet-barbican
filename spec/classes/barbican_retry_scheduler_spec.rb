require 'spec_helper'

describe 'barbican::retry_scheduler' do
  let :params do
    {}
  end

  shared_examples 'barbican::retry_scheduler' do
    context 'with defaults' do
      it 'configures retry scheduler parameters' do
        is_expected.to contain_barbican_config('retry_scheduler/initial_delay_seconds')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('retry_scheduler/periodic_interval_max_seconds')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      before do
        params.merge!({
          :initial_delay_seconds         => 10,
          :periodic_interval_max_seconds => 11,
        })
      end
      it 'configures retry scheduler parameters' do
        is_expected.to contain_barbican_config('retry_scheduler/initial_delay_seconds')\
          .with_value(10)
        is_expected.to contain_barbican_config('retry_scheduler/periodic_interval_max_seconds')\
          .with_value(11)
      end
    end
  end

  shared_examples 'barbican::retry_scheduler in RedHat' do
    it 'installs barbican-retry package' do
      is_expected.to contain_package('barbican-retry').with(
        :ensure => 'present',
        :name   => platform_params[:retry_package_name],
        :tag    => ['openstack', 'barbican-package']
      )
    end

    it 'configures barbican-retry service' do
      is_expected.to contain_service('barbican-retry').with(
        :ensure     => 'running',
        :name       => platform_params[:retry_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'barbican-service'
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {}
        when 'RedHat'
          {
            :retry_package_name => 'openstack-barbican-retry',
            :retry_service_name => 'openstack-barbican-retry'
          }
        end
      end

      it_behaves_like 'barbican::retry_scheduler'
      if facts[:os]['family'] == 'RedHat'
        it_behaves_like 'barbican::retry_scheduler in RedHat'
      end
    end
  end
end
