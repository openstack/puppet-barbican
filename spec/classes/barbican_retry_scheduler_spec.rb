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

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    let (:facts) do
      facts.merge(OSDefaults.get_facts())
    end

    context "on #{os}" do
      it_behaves_like 'barbican::retry_scheduler'
    end
  end
end
