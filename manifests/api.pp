# == Class: barbican::api
#
# The barbican::api class encapsulates a Barbican API service running
# in a gunicorn container.
#
# === Parameters
#
# [*package_ensure*]
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
# [*max_allowed_secret_in_bytes*]
#   (optional) Maximum allowed secret size to be stored.
#   Defaults to $::os_service_default
#
# [*max_allowed_request_size_in_bytes*]
#   (optional) Maximum request size against the barbican API.
#   Defaults to $::os_service_default
#
# [*default_transport_url*]
#   (optional) Connection url for oslo messaging backend. An example rabbit url
#   would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (optional) Connection url for oslo messaging notifications backend. An
#   example rabbit url would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (optional) Driver to use for oslo messaging notifications backend.
#   Defaults to $::os_service_default
#
# [*notification_topics*]
#   (optional) Topics to use for oslo messaging notifications backend.
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
#   Defaults to $::os_service_default
#
# [*queue_namespace*]
#   (optional) Namespace for the queue
#   Defaults to $::os_service_default
#
# [*queue_topic*]
#   (optional) Topic for the queue
#   Defaults to $::os_service_default
#
# [*queue_version*]
#   (optional) Version for the task API
#   Defaults to $::os_service_default
#
# [*queue_server_name*]
#   (optional) Server name for RPC service
#   Defaults to $::os_service_default
#
# [*retry_scheduler_initial_delay_seconds*]
#   (optional) Seconds (float) to wait before starting retry scheduler
#   Defaults to $::os_service_default
#
# [*retry_scheduler_periodic_interval_max_seconds*]
#   (optional) Seconds (float) to wait between starting retry scheduler
#   Defaults to $::os_service_default
#
# [*enabled_secretstore_plugins*]
#   (optional) Enabled secretstore plugins. Multiple plugins
#   are defined in a list eg. ['store_crypto', dogtag_crypto']
#   Used when multiple_secret_stores_enabled is not set to true.
#   Defaults to $::os_service_default
#
# [*enabled_crypto_plugins*]
#   (optional) Enabled crypto_plugins.  Multiple plugins
#   are defined in a list eg. ['simple_crypto','p11_crypto']
#   Used when multiple_secret_stores_enabled is not set to true.
#   Defaults to $::os_service_default
#
# [*enabled_secret_stores*]
#   (optional) Enabled secretstores. This is the configuration
#   parameters when multiple plugin configuration is used.
#   Suffixes are defined in a comma separated list eg.
#   'simple_crypto,dogtag,kmip,pkcs11'
#   Defaults to 'simple_crypto'
#
# [*multiple_secret_stores_enabled*]
#   (optional) Enabled crypto_plugins.  Multiple plugins
#   are defined in a list eg. ['simple_crypto','p11_crypto']
#   Defaults to false
#
# [*enabled_certificate_plugins*]
#   (optional) Enabled certificate plugins as a list.
#   e.g. ['snakeoil_ca', 'dogtag']
#   Defaults to $::os_service_default
#
# [*enabled_certificate_event_plugins*]
#   (optional) Enabled certificate event plugins as a list
#   Defaults to $::os_service_default
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
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*auth_strategy*]
#   (optional) authentication type
#   Defaults to 'keystone'
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*sync_db*]
#   (optional) Run barbican-db-manage on api nodes.
#   Defaults to true
#
# [*db_auto_create*]
#   (optional) Barbican API server option to create the database
#   automatically when the server starts.
#   Defaults to $::os_service_default
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of barbican-api.
#   If the value is 'httpd', this means barbican-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'barbican::wsgi::apache'...}
#   to make barbican-api be a web app using apache mod_wsgi.
#   Defaults to 'barbican-api'
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
class barbican::api (
  $package_ensure                                = 'present',
  $client_package_ensure                         = 'present',
  $bind_host                                     = '0.0.0.0',
  $bind_port                                     = '9311',
  $host_href                                     = undef,
  $max_allowed_secret_in_bytes                   = $::os_service_default,
  $max_allowed_request_size_in_bytes             = $::os_service_default,
  $default_transport_url                         = $::os_service_default,
  $rpc_response_timeout                          = $::os_service_default,
  $control_exchange                              = $::os_service_default,
  $notification_transport_url                    = $::os_service_default,
  $notification_driver                           = $::os_service_default,
  $notification_topics                           = $::os_service_default,
  $rabbit_use_ssl                                = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold            = $::os_service_default,
  $rabbit_heartbeat_rate                         = $::os_service_default,
  $rabbit_ha_queues                              = $::os_service_default,
  $amqp_durable_queues                           = $::os_service_default,
  $enable_queue                                  = $::os_service_default,
  $queue_namespace                               = $::os_service_default,
  $queue_topic                                   = $::os_service_default,
  $queue_version                                 = $::os_service_default,
  $queue_server_name                             = $::os_service_default,
  $retry_scheduler_initial_delay_seconds         = $::os_service_default,
  $retry_scheduler_periodic_interval_max_seconds = $::os_service_default,
  $enabled_secretstore_plugins                   = $::os_service_default,
  $enabled_crypto_plugins                        = $::os_service_default,
  $enabled_secret_stores                         = 'simple_crypto',
  $multiple_secret_stores_enabled                = false,
  $enabled_certificate_plugins                   = $::os_service_default,
  $enabled_certificate_event_plugins             = $::os_service_default,
  $kombu_ssl_ca_certs                            = $::os_service_default,
  $kombu_ssl_certfile                            = $::os_service_default,
  $kombu_ssl_keyfile                             = $::os_service_default,
  $kombu_ssl_version                             = $::os_service_default,
  $kombu_reconnect_delay                         = $::os_service_default,
  $kombu_failover_strategy                       = $::os_service_default,
  $kombu_compression                             = $::os_service_default,
  $auth_strategy                                 = 'keystone',
  $manage_service                                = true,
  $enabled                                       = true,
  $sync_db                                       = true,
  $db_auto_create                                = $::os_service_default,
  $use_ssl                                       = false,
  $ca_file                                       = $::os_service_default,
  $cert_file                                     = $::os_service_default,
  $key_file                                      = $::os_service_default,
  $service_name                                  = 'barbican-api',
  $enable_proxy_headers_parsing                  = $::os_service_default,
) inherits barbican::params {

  include ::barbican::deps
  include ::barbican::db
  include ::barbican::api::logging
  include ::barbican::client
  include ::barbican::policy

  # TODO: Remove the posix users and permissions and merge this definition
  # with the previous one, once the barbican package has been updated
  # with the correct ownership for this directory.
  file { ['/var/lib/barbican']:
    ensure  => directory,
    mode    => '0770',
    owner   => 'root',
    group   => 'barbican',
    require => Anchor['barbican::install::end'],
    notify  => Anchor['barbican::service::end'],
  }

  package { 'barbican-api':
    ensure => $package_ensure,
    name   => $::barbican::params::api_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

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

  oslo::messaging::rabbit {'barbican_config':
    rabbit_use_ssl              => $rabbit_use_ssl,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    amqp_durable_queues         => $amqp_durable_queues,
    kombu_compression           => $kombu_compression,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    rabbit_ha_queues            => $rabbit_ha_queues,
  }

  oslo::messaging::default { 'barbican_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'barbican_config':
    driver        => $notification_driver,
    transport_url => $notification_transport_url,
    topics        => $notification_topics,
  }

  # queue options
  barbican_config {
    'queue/enable':      value => $enable_queue;
    'queue/namespace':   value => $queue_namespace;
    'queue/topic':       value => $queue_topic;
    'queue/version':     value => $queue_version;
    'queue/server_name': value => $queue_server_name;
  }

  # retry scheduler and max allowed secret options
  barbican_config {
    'retry_scheduler/initial_delay_seconds':         value => $retry_scheduler_initial_delay_seconds;
    'retry_scheduler/periodic_interval_max_seconds': value => $retry_scheduler_periodic_interval_max_seconds;
    'DEFAULT/max_allowed_secret_in_bytes':           value => $max_allowed_secret_in_bytes;
    'DEFAULT/max_allowed_request_size_in_bytes':     value => $max_allowed_request_size_in_bytes;
  }

  if $multiple_secret_stores_enabled and !is_service_default($enabled_secretstore_plugins) {
    warning("barbican::api::enabled_secretstore_plugins and barbican::api::enabled_crypto_plugins \
      will be set by puppet, but will not be used by the server whenever \
      barbican::api::multiple_secret_stores_enabled is set to true.  Use \
      barbican::api::enabled_secret_stores instead")
  }

  # enabled plugins
  barbican_config {
    'secretstore/enabled_secretstore_plugins':             value => $enabled_secretstore_plugins;
    'crypto/enabled_crypto_plugins':                       value => $enabled_crypto_plugins;
    'certificate/enabled_certificate_plugins':             value => $enabled_certificate_plugins;
    'certificate_event/enabled_certificate_event_plugins': value => $enabled_certificate_event_plugins;
  }

  # enabled plugins when multiple plugins is enabled
  barbican_config {
    'secretstore/enable_multiple_secret_stores': value => $multiple_secret_stores_enabled;
    'secretstore/stores_lookup_suffix':          value => $enabled_secret_stores;
  }

  # keystone config
  if $auth_strategy == 'keystone' {

    include ::barbican::keystone::authtoken

    barbican_api_paste_ini {
      'pipeline:barbican_api/pipeline': value => 'cors authtoken context apiapp';
    }

  } else {
    barbican_api_paste_ini {
      'pipeline:barbican_api/pipeline': value => 'cors unauthenticated-context apiapp';
    }

    barbican_config {
      'keystone_authtoken/auth_plugin':          ensure => 'absent';
      'keystone_authtoken/auth_type':            ensure => 'absent';
      'keystone_authtoken/www_authenticate_uri': ensure => 'absent';
      'keystone_authtoken/project_name':         ensure => 'absent';
      'keystone_authtoken/username':             ensure => 'absent';
      'keystone_authtoken/password':             ensure => 'absent';
      'keystone_authtoken/user_domain_id':       ensure => 'absent';
      'keystone_authtoken/project_domain_id':    ensure => 'absent';
    }
  }


  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  # set value to have the server auto-create the database on startup
  # instead of using db_sync
  barbican_config { 'DEFAULT/db_auto_create': value => $db_auto_create }

  if $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  # SSL Options
  barbican_config {
    'DEFAULT/cert_file': value => $cert_file;
    'DEFAULT/key_file':  value => $key_file;
    'DEFAULT/ca_file':   value => $ca_file;
  }

  if $sync_db {
    include ::barbican::db::sync
  }

  if $service_name == 'barbican-api' {
    if $::os_package_type == 'ubuntu' {
      fail('With Ubuntu packages the service_name must be set to httpd as there is no eventlet init script.')
    }
    service { 'barbican-api':
      ensure     => $service_ensure,
      name       => $::barbican::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'barbican-service',
    }

    file_line { 'Modify bind_port in gunicorn-config.py':
      path  => '/etc/barbican/gunicorn-config.py',
      line  => "bind = '${bind_host}:${bind_port}'",
      match => '.*bind = .*',
      tag   => 'modify-bind-port',
    }

  } elsif $service_name == 'httpd' {
    include ::apache::params
    # Ubuntu packages does not have a barbican-api service
    if $::os_package_type != 'ubuntu' {
      service { 'barbican-api':
        ensure => 'stopped',
        name   => $::barbican::params::api_service_name,
        enable => false,
        tag    => 'barbican-service',
      }
      # we need to make sure barbican-api is stopped before trying to start apache
      Service['barbican-api'] -> Service[$service_name]
    }
  } else {
    fail('Invalid service_name. Use barbican-api for stand-alone or httpd')
  }

  oslo::middleware { 'barbican_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

}
