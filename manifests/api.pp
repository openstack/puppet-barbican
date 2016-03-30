# == Class: barbican::api
#
# The barbican::api class encapsulates a Barbican API service running
# in a gunicorn container.
#
# === Parameters
#
# [*ensure_package*]
#   (optional) The state of barbican packages
#   Defaults to 'present'
#
# [*client_package_ensure*]
#   (optional) Desired ensure state of the client package.
#   accepts latest or specific versions.
#   Defaults to 'present'.
#
# [*bind_host*]
#   (optional) The IP address of the network interface to listen on
#   Default to '0.0.0.0'.
#
# [*bind_port*]
#   (optional) Port that barbican binds to.
#   Defaults to '9311'
#
# [*host_href*]
#   (optional) The reference that clients use to point back to the service
#   Defaults to http://`hostname`:<bind_port>
#   TODO: needs to be set
#
# [*rpc_backend*]
#   (optional) The rpc backend implementation to use, can be:
#     rabbit (for rabbitmq)
#     qpid (for qpid)
#     zmq (for zeromq)
#   Defaults to 'rabbit'
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation.
#   Defaults to 'localhost'
#
# [*rabbit_hosts*]
#   (optional) List of clustered rabbit servers.
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance.
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq.
#   Defaults to $::os_service_default
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq.
#   Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#   (optional) The RabbitMQ virtual host.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ.
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $::os_service_default
#
# [*enable_queue*]
#   (optional) Enable asynchronous queuing
#   Defaults to False
#
# [*queue_namespace*]
#   (optional) Namespace for the queue
#   Defaults to barbican
#
# [*queue_topic*]
#   (optional) Topic for the queue
#   Defaults to barbican.workers
#
# [*queue_version*]
#   (optional) Version for the task API
#   Defaults to 1.1
#
# [*queue_server_name*]
#   (optional) Server name for RPC service
#   Defaults to 'barbican.queue'
#
# [*retry_scheduler_initial_delay_seconds*]
#   (optional) Seconds (float) to wait before starting retry scheduler
#   Defaults to 10.0
#
# [*retry_scheduler_periodic_interval_max_seconds*]
#   (optional) Seconds (float) to wait between starting retry scheduler
#   Defaults to 10.0
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
class barbican::api (
  $ensure_package                     = 'present',
  $client_package_ensure              = 'present',
  $bind_host                          = '0.0.0.0',
  $bind_port                          = '9311',
  $host_href                          = undef,
  $rpc_backend                        = $::os_service_default,
  $rabbit_host                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $enable_queue                       = $::os_service_default,
  $queue_namespace                    = $::os_service_default,
  $queue_topic                        = $::os_service_default,
  $queue_version                      = $::os_service_default,
  $queue_server_name                  = $::os_service_default,
  $retry_scheduler_initial_delay_seconds
                                      = $::os_service_default,
  $retry_scheduler_periodic_interval_max_seconds
                                      = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $manage_service                     = true,
  $enabled                            = true,
) inherits barbican::params {

  include ::barbican::db
  include ::barbican::api::logging
  include ::barbican::client

  file { ['/etc/barbican', '/var/log/barbican']:
    ensure  => directory,
    require => Package['barbican-api'],
    notify  => Service['barbican-api'],
  }

  # TODO: Remove the posix users and permissions and merge this definition
  # with the previous one, once the barbican package has been updated
  # with the correct ownership for this directory.
  file { ['/var/lib/barbican']:
    ensure  => directory,
    mode    => '0770',
    owner   => 'root',
    group   => 'barbican',
    require => Package['barbican-api'],
    notify  => Service['barbican-api'],
  }

  file { ['/etc/barbican/barbican.conf',
          '/etc/barbican/barbican-api-paste.ini',
          '/etc/barbican/gunicorn-config.py']:
    ensure  => present,
    require => Package['barbican-api'],
    notify  => Service['barbican-api'],
  }

  package { 'barbican-api':
    ensure => $ensure_package,
    name   => $::barbican::params::api_package_name,
    tag    => ['openstack', 'barbican-api-package'],
  }

  File['/etc/barbican/barbican.conf']          -> Barbican_config<||>
  File['/etc/barbican/barbican-api-paste.ini'] -> Barbican_api_paste_ini<||>
  Barbican_config<||>                          ~> Service['barbican-api']
  Barbican_api_paste_ini<||>                   ~> Service['barbican-api']

  # basic service config
  if $host_href == undef {
    $host_href_real = "http://${::fqdn}:${bind_port}"
  } else {
    $host_href_real = $host_href
  }

  barbican_config {
    'DEFAULT/bind_host': value => $bind_host;
    'DEFAULT/bind_port': value => $bind_port;
    'DEFAULT/host_href': value => $host_href_real;
  }

  File['/etc/barbican/gunicorn-config.py'] ->
    file_line { 'Modify bind_port in gunicorn-config.py':
      path  => '/etc/barbican/gunicorn-config.py',
      line  => "bind = '${bind_host}:${bind_port}'",
      match => '.*bind = .*',
    } -> Service['barbican-api']

  #rabbit config
  if $rpc_backend in [$::os_service_default, 'rabbit'] {
    oslo::messaging::rabbit {'barbican_config':
      rabbit_password             => $rabbit_password,
      rabbit_userid               => $rabbit_userid,
      rabbit_virtual_host         => $rabbit_virtual_host,
      rabbit_use_ssl              => $rabbit_use_ssl,
      heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate              => $rabbit_heartbeat_rate,
      kombu_reconnect_delay       => $kombu_reconnect_delay,
      amqp_durable_queues         => $amqp_durable_queues,
      kombu_compression           => $kombu_compression,
      kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
      kombu_ssl_certfile          => $kombu_ssl_certfile,
      kombu_ssl_keyfile           => $kombu_ssl_keyfile,
      kombu_ssl_version           => $kombu_ssl_version,
      rabbit_hosts                => $rabbit_hosts,
      rabbit_host                 => $rabbit_host,
      rabbit_port                 => $rabbit_port,
      rabbit_ha_queues            => $rabbit_ha_queues,
    }
  } else {
    barbican_config { 'DEFAULT/rpc_backend': value => $rpc_backend }
  }

  # queue options
  barbican_config {
    'queue/enable':      value => $enable_queue;
    'queue/namespace':   value => $queue_namespace;
    'queue/topic':       value => $queue_topic;
    'queue/version':     value => $queue_version;
    'queue/server_name': value => $queue_server_name;
  }

  # retry scheduler options
  barbican_config {
    'retry_scheduler/initial_delay_seconds':         value => $retry_scheduler_initial_delay_seconds;
    'retry_scheduler/periodic_interval_max_seconds': value => $retry_scheduler_periodic_interval_max_seconds;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'barbican-api':
    ensure     => $service_ensure,
    name       => $::barbican::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'barbican-service',
  }

}
