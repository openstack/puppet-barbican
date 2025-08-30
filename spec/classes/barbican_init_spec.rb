require 'spec_helper'

describe 'barbican' do

  shared_examples 'barbican' do

    it { is_expected.to contain_class('barbican::deps') }

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'installs packages' do
        is_expected.to contain_package('barbican').with(
          :name   => platform_params[:barbican_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'barbican-package']
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('barbican_config').with({
          :purge => false
        })
      end

      it 'configures queue_options' do
        is_expected.to contain_barbican_config('queue/enable').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('queue/namespace').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('queue/topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('queue/version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_barbican_config('queue/server_name').with_value('<SERVICE DEFAULT>')
      end

      it 'configures rabbitmq parameters' do
        is_expected.to contain_oslo__messaging__default('barbican_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('barbican_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__rabbit('barbican_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :amqp_auto_delete                => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
      end
    end 

    context 'with parameters' do
      let :params do
        {
          :default_transport_url              => 'rabbit://bugs:bugs_bunny@localhost:1234/rabbithost',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'barbican',
          :notification_transport_url         => 'rabbit://bugs:bugs_bunny@localhost:1234/rabbithost',
          :notification_driver                => 'kombu',
          :notification_topics                => 'notifications',
          :notification_retry                 => 10,
          :rabbit_use_ssl                     => true,
          :rabbit_heartbeat_timeout_threshold => '10',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_qos_prefetch_count          => 0,
          :rabbit_ha_queues                   => true,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => true,
          :rabbit_transient_queues_ttl        => 60,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_queue_manager           => true,
          :rabbit_stream_fanout               => true,
          :rabbit_enable_cancel_on_failover   => false,
          :amqp_durable_queues                => true,
          :amqp_auto_delete                   => true,
          :queue_enable                       => true,
          :queue_namespace                    => 'barbican1',
          :queue_topic                        => 'barbican1.workers',
          :queue_version                      => '1.2',
          :queue_server_name                  => 'barbican1.queue',
          :kombu_ssl_ca_certs                 => 'path_to_certs',
          :kombu_ssl_certfile                 => 'path_to_certfile',
          :kombu_ssl_keyfile                  => 'path_to_keyfile',
          :kombu_ssl_version                  => '1.2',
          :kombu_reconnect_delay              => '10',
          :kombu_failover_strategy            => 'shuffle',
          :kombu_compression                  => 'gzip',
        }
      end

      it 'configures queue_options' do
        is_expected.to contain_barbican_config('queue/enable').with_value(params[:queue_enable])
        is_expected.to contain_barbican_config('queue/namespace').with_value(params[:queue_namespace])
        is_expected.to contain_barbican_config('queue/topic').with_value(params[:queue_topic])
        is_expected.to contain_barbican_config('queue/version').with_value(params[:queue_version])
        is_expected.to contain_barbican_config('queue/server_name').with_value(params[:queue_server_name])
      end

      it 'configures rabbitmq parameters' do
        is_expected.to contain_oslo__messaging__default('barbican_config').with(
          :transport_url        => params[:default_transport_url],
          :rpc_response_timeout => params[:rpc_response_timeout],
          :control_exchange     => params[:control_exchange]
        )
        is_expected.to contain_oslo__messaging__notifications('barbican_config').with(
          :transport_url => params[:notification_transport_url],
          :driver        => params[:notification_driver],
          :topics        => params[:notification_topics],
          :retry         => params[:notification_retry],
        )
        is_expected.to contain_oslo__messaging__rabbit('barbican_config').with(
          :rabbit_use_ssl                  => params[:rabbit_use_ssl],
          :heartbeat_timeout_threshold     => params[:rabbit_heartbeat_timeout_threshold],
          :heartbeat_rate                  => params[:rabbit_heartbeat_rate],
          :rabbit_qos_prefetch_count       => params[:rabbit_qos_prefetch_count],
          :kombu_reconnect_delay           => params[:kombu_reconnect_delay],
          :kombu_failover_strategy         => params[:kombu_failover_strategy],
          :amqp_durable_queues             => params[:amqp_durable_queues],
          :amqp_auto_delete                => params[:amqp_auto_delete],
          :kombu_compression               => params[:kombu_compression],
          :kombu_ssl_ca_certs              => params[:kombu_ssl_ca_certs],
          :kombu_ssl_certfile              => params[:kombu_ssl_certfile],
          :kombu_ssl_keyfile               => params[:kombu_ssl_keyfile],
          :kombu_ssl_version               => params[:kombu_ssl_version],
          :rabbit_ha_queues                => params[:rabbit_ha_queues],
          :rabbit_quorum_queue             => params[:rabbit_quorum_queue],
          :rabbit_transient_quorum_queue   => params[:rabbit_transient_quorum_queue],
          :rabbit_transient_queues_ttl     => params[:rabbit_transient_queues_ttl],
          :rabbit_quorum_delivery_limit    => params[:rabbit_quorum_delivery_limit],
          :rabbit_quorum_max_memory_length => params[:rabbit_quorum_max_memory_length],
          :rabbit_quorum_max_memory_bytes  => params[:rabbit_quorum_max_memory_bytes],
          :use_queue_manager               => params[:rabbit_use_queue_manager],
          :rabbit_stream_fanout            => params[:rabbit_stream_fanout],
          :enable_cancel_on_failover       => params[:rabbit_enable_cancel_on_failover],
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :barbican_common_package => 'barbican-common' }
        when 'RedHat'
          { :barbican_common_package => 'openstack-barbican-common' }
        end
      end
      it_behaves_like 'barbican'
    end
  end
end
