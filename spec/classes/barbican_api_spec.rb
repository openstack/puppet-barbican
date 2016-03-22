require 'spec_helper'

describe 'barbican::api' do

  let :facts do
    @default_facts.merge(
      {
        :osfamily       => 'RedHat',
        :processorcount => '7',
      }
    )
  end

  let :default_params do
    {
      :bind_host                          => '0.0.0.0',
      :bind_port                          => '9311',
      :rpc_backend                        => 'rabbit',
      :rabbit_host                        => '<SERVICE_DEFAULT>',
      :rabbit_hosts                       => ['<SERVICE DEFAULT>'],
      :rabbit_password                    => '<SERVICE DEFAULT>',
      :rabbit_port                        => '<SERVICE DEFAULT>',
      :rabbit_userid                      => '<SERVICE DEFAULT>',
      :rabbit_virtual_host                => '<SERVICE DEFAULT>',
      :rabbit_use_ssl                     => '<SERVICE DEFAULT>',
      :rabbit_heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
      :rabbit_heartbeat_rate              => '<SERVICE DEFAULT>',
      :rabbit_ha_queues                   => '<SERVICE DEFAULT>',
      :amqp_durable_queues                => '<SERVICE DEFAULT>',
      :enable_queue                       => '<SERVICE DEFAULT>',
      :queue_namespace                    => '<SERVICE DEFAULT>',
      :queue_topic                        => '<SERVICE DEFAULT>',
      :queue_version                      => '<SERVICE DEFAULT>',
      :queue_server_name                  => '<SERVICE DEFAULT>',
      :manage_service                     => true,
      :enabled                            => true,
      :kombu_ssl_ca_certs                 => '<SERVICE DEFAULT>',
      :kombu_ssl_certfile                 => '<SERVICE DEFAULT>',
      :kombu_ssl_keyfile                  => '<SERVICE DEFAULT>',
      :kombu_ssl_version                  => '<SERVICE DEFAULT>',
      :kombu_reconnect_delay              => '<SERVICE DEFAULT>',
      :retry_scheduler_initial_delay_seconds         => '<SERVICE DEFAULT>',
      :retry_scheduler_periodic_interval_max_seconds => '<SERVICE DEFAULT>',
    }
  end

  [{},
   {
      :bind_host                          => '127.0.0.1',
      :bind_port                          => '9312',
      :rpc_backend                        => 'rabbit',
      :rabbit_host                        => 'rabbithost',
      :rabbit_hosts                       => ['rabbithost:1234'],
      :rabbit_password                    => 'bugs_bunny',
      :rabbit_port                        => '1234',
      :rabbit_userid                      => 'bugs',
      :rabbit_virtual_host                => 'rabbithost',
      :rabbit_use_ssl                     => true,
      :rabbit_heartbeat_timeout_threshold => '10',
      :rabbit_heartbeat_rate              => '10',
      :rabbit_ha_queues                   => true,
      :amqp_durable_queues                => true,
      :enable_queue                       => true,
      :queue_namespace                    => 'barbican1',
      :queue_topic                        => 'barbican1.workers',
      :queue_version                      => '1.2',
      :queue_server_name                  => 'barbican1.queue',
      :manage_service                     => true,
      :enabled                            => false,
      :kombu_ssl_ca_certs                 => 'path_to_certs',
      :kombu_ssl_certfile                 => 'path_to_certfile',
      :kombu_ssl_keyfile                  => 'path_to_keyfile',
      :kombu_ssl_version                  => '1.2',
      :kombu_reconnect_delay              => '10',
      :retry_scheduler_initial_delay_seconds         => 20.0,
      :retry_scheduler_periodic_interval_max_seconds => 20.0,
    }
  ].each do |param_set|

    describe "when #{param_set == {} ? "using default" : "specifying"} class parameters" do

      let :param_hash do
        default_params.merge(param_set)
      end

      let :params do
        param_set
      end

      let :host_ref do
        "http://${::fqdn}:$param_hash[:bind_port]"
      end

      it { is_expected.to contain_class 'barbican::api::logging' }
      it { is_expected.to contain_class 'barbican::db' }

      it { is_expected.to contain_service('barbican-api').with(
        'ensure'     => (param_hash[:manage_service] && param_hash[:enabled]) ? 'running': 'stopped',
        'enable'     => param_hash[:enabled],
        'hasstatus'  => true,
        'hasrestart' => true,
        'tag'        => 'barbican-service',
      ) }

      it 'is_expected.to set default parameters' do
        [
          'bind_host',
          'bind_port',
        ].each do |config|
          is_expected.to contain_barbican_config("DEFAULT/#{config}").with_value(param_hash[config.intern])
        end
      end

      it 'configures queue' do
        is_expected.to contain_barbican_config('queue/enable').with_value(param_hash[:enable_queue])
        is_expected.to contain_barbican_config('queue/namespace').with_value(param_hash[:queue_namespace])
        is_expected.to contain_barbican_config('queue/topic').with_value(param_hash[:queue_topic])
        is_expected.to contain_barbican_config('queue/version').with_value(param_hash[:queue_version])
        is_expected.to contain_barbican_config('queue/server_name').with_value(param_hash[:queue_server_name])
      end

      it 'configures rabbit' do
        is_expected.to contain_barbican_config('DEFAULT/rpc_backend').with_value(param_hash[:rpc_backend])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/rabbit_hosts').with_value(param_hash[:rabbit_hosts])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/rabbit_password').with_value(param_hash[:rabbit_password]).with_secret(true)
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/rabbit_userid').with_value(param_hash[:rabbit_userid])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value(param_hash[:rabbit_virtual_host])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value(param_hash[:rabbit_heartbeat_timeout_threshold])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/heartbeat_rate').with_value(param_hash[:rabbit_heartbeat_rate])
      end

      it 'configures kombu certs' do
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value(param_hash[:kombu_ssl_ca_certs])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value(param_hash[:kombu_ssl_certfile])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value(param_hash[:kombu_ssl_keyfile])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/kombu_ssl_version').with_value(param_hash[:kombu_ssl_version])
        is_expected.to contain_barbican_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value(param_hash[:kombu_reconnect_delay])
      end
    end
  end

  describe 'with disabled service managing' do
    let :params do
      {
        :manage_service => false,
        :enabled        => false,
      }
    end

    it { is_expected.to contain_service('barbican-api').with(
        'ensure'     => nil,
        'enable'     => false,
        'hasstatus'  => true,
        'hasrestart' => true,
        'tag'        => 'barbican-service',
      ) }
  end

  describe 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7',
      })
    end
    let(:params) { default_params }

    it { is_expected.to contain_package('barbican-api').with(
        :tag => ['openstack', 'barbican-api-package'],
    )}
  end

  describe 'on unknown platforms' do
    let :facts do
      { :osfamily => 'unknown' }
    end
    let(:params) { default_params }

    it_raises 'a Puppet::Error', /Unsupported osfamily/
  end

end
