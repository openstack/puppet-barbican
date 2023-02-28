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
#   Defaults to $facts['os_service_default']
#
# [*max_allowed_request_size_in_bytes*]
#   (optional) Maximum request size against the barbican API.
#   Defaults to $facts['os_service_default']
#
# [*default_transport_url*]
#   (optional) Connection url for oslo messaging backend. An example rabbit url
#   would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) Connection url for oslo messaging notifications backend. An
#   example rabbit url would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (optional) Driver to use for oslo messaging notifications backend.
#   Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#   (optional) Topics to use for oslo messaging notifications backend.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $facts['os_service_default']
#
# [*enable_queue*]
#   (optional) Enable asynchronous queuing
#   Defaults to $facts['os_service_default']
#
# [*queue_namespace*]
#   (optional) Namespace for the queue
#   Defaults to $facts['os_service_default']
#
# [*queue_topic*]
#   (optional) Topic for the queue
#   Defaults to $facts['os_service_default']
#
# [*queue_version*]
#   (optional) Version for the task API
#   Defaults to $facts['os_service_default']
#
# [*queue_server_name*]
#   (optional) Server name for RPC service
#   Defaults to $facts['os_service_default']
#
# [*enabled_secretstore_plugins*]
#   (optional) Enabled secretstore plugins. Multiple plugins
#   are defined in a list eg. ['store_crypto', dogtag_crypto']
#   Used when multiple_secret_stores_enabled is not set to true.
#   Defaults to $facts['os_service_default']
#
# [*enabled_crypto_plugins*]
#   (optional) Enabled crypto_plugins.  Multiple plugins
#   are defined in a list eg. ['simple_crypto','p11_crypto']
#   Used when multiple_secret_stores_enabled is not set to true.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*enabled_certificate_event_plugins*]
#   (optional) Enabled certificate event plugins as a list
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of barbican-api.
#   If the value is 'httpd', this means barbican-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'barbican::wsgi::apache'...}
#   to make barbican-api be a web app using apache mod_wsgi.
#   Defaults to $::barbican::params::api_service_name
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*max_limit_paging*]
#   (Optional) Maximum page size for the 'limit' paging URL parameter.
#   Defaults to $facts['os_service_default']
#
# [*default_limit_paging*]
#   (Optional) Default page size for the 'limit' paging URL parameter.
#   Defaults to $facts['os_service_default']
#
class barbican::api (
  $package_ensure                                = 'present',
  $bind_host                                     = '0.0.0.0',
  $bind_port                                     = '9311',
  $host_href                                     = undef,
  $max_allowed_secret_in_bytes                   = $facts['os_service_default'],
  $max_allowed_request_size_in_bytes             = $facts['os_service_default'],
  $default_transport_url                         = $facts['os_service_default'],
  $rpc_response_timeout                          = $facts['os_service_default'],
  $control_exchange                              = $facts['os_service_default'],
  $notification_transport_url                    = $facts['os_service_default'],
  $notification_driver                           = $facts['os_service_default'],
  $notification_topics                           = $facts['os_service_default'],
  $rabbit_use_ssl                                = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold            = $facts['os_service_default'],
  $rabbit_heartbeat_rate                         = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread                   = $facts['os_service_default'],
  $rabbit_ha_queues                              = $facts['os_service_default'],
  $amqp_durable_queues                           = $facts['os_service_default'],
  $enable_queue                                  = $facts['os_service_default'],
  $queue_namespace                               = $facts['os_service_default'],
  $queue_topic                                   = $facts['os_service_default'],
  $queue_version                                 = $facts['os_service_default'],
  $queue_server_name                             = $facts['os_service_default'],
  $enabled_secretstore_plugins                   = $facts['os_service_default'],
  $enabled_crypto_plugins                        = $facts['os_service_default'],
  $enabled_secret_stores                         = 'simple_crypto',
  $multiple_secret_stores_enabled                = false,
  $enabled_certificate_plugins                   = $facts['os_service_default'],
  $enabled_certificate_event_plugins             = $facts['os_service_default'],
  $kombu_ssl_ca_certs                            = $facts['os_service_default'],
  $kombu_ssl_certfile                            = $facts['os_service_default'],
  $kombu_ssl_keyfile                             = $facts['os_service_default'],
  $kombu_ssl_version                             = $facts['os_service_default'],
  $kombu_reconnect_delay                         = $facts['os_service_default'],
  $kombu_failover_strategy                       = $facts['os_service_default'],
  $kombu_compression                             = $facts['os_service_default'],
  $auth_strategy                                 = 'keystone',
  $manage_service                                = true,
  $enabled                                       = true,
  $sync_db                                       = true,
  $db_auto_create                                = $facts['os_service_default'],
  $service_name                                  = $::barbican::params::api_service_name,
  $enable_proxy_headers_parsing                  = $facts['os_service_default'],
  $max_request_body_size                         = $facts['os_service_default'],
  $max_limit_paging                              = $facts['os_service_default'],
  $default_limit_paging                          = $facts['os_service_default'],
) inherits barbican::params {

  include barbican::deps
  include barbican::db
  include barbican::client
  include barbican::policy

  validate_legacy(Boolean, 'validate_bool', $manage_service)
  validate_legacy(Boolean, 'validate_bool', $enabled)
  validate_legacy(Boolean, 'validate_bool', $sync_db)
  validate_legacy(Boolean, 'validate_bool', $multiple_secret_stores_enabled)

  package { 'barbican-api':
    ensure => $package_ensure,
    name   => $::barbican::params::api_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

  # basic service config
  if $host_href == undef {
    $host_href_real = "http://${facts['networking']['fqdn']}:${bind_port}"
  } else {
    $host_href_real = $host_href
  }

  barbican_config {
    'DEFAULT/bind_host': ensure => absent;
    'DEFAULT/bind_port': ensure => absent;
  }

  barbican_config {
    'DEFAULT/host_href': value => $host_href_real;
  }

  oslo::messaging::rabbit {'barbican_config':
    rabbit_use_ssl              => $rabbit_use_ssl,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    heartbeat_in_pthread        => $rabbit_heartbeat_in_pthread,
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

  # max allowed secret options
  barbican_config {
    'DEFAULT/max_allowed_secret_in_bytes':       value => $max_allowed_secret_in_bytes;
    'DEFAULT/max_allowed_request_size_in_bytes': value => $max_allowed_request_size_in_bytes;
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
    include barbican::keystone::authtoken
    barbican_api_paste_ini {
      'composite:main//v1': value => 'barbican-api-keystone', key_val_separator => ':';
    }
  } else {
    barbican_api_paste_ini {
      'composite:main//v1': value => 'barbican_api', key_val_separator => ':';
    }
  }

  # set value to have the server auto-create the database on startup
  # instead of using db_sync
  barbican_config { 'DEFAULT/db_auto_create': value => $db_auto_create }

  if $sync_db {
    include barbican::db::sync
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $service_name == $::barbican::params::api_service_name {

      if $facts['os']['name'] == 'Ubuntu' {
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

      # Debian is using UWSGI, not gunicorn
      if $facts['os']['name'] != 'Debian' {
        file_line { 'Modify bind_port in gunicorn-config.py':
          path  => '/etc/barbican/gunicorn-config.py',
          line  => "bind = '${bind_host}:${bind_port}'",
          match => '^bind = .*',
          tag   => 'modify-bind-port',
        }
      }

    } elsif $service_name == 'httpd' {
      # Ubuntu packages does not have a barbican-api service
      if $facts['os']['name'] != 'Ubuntu' {
        service { 'barbican-api':
          ensure => 'stopped',
          name   => $::barbican::params::api_service_name,
          enable => false,
          tag    => 'barbican-service',
        }
        Service <| title == 'httpd' |> { tag +> 'barbican-service' }

        # we need to make sure barbican-api is stopped before trying to start apache
        Service['barbican-api'] -> Service[$service_name]
      }
    } else {
      fail('Invalid service_name.')
    }
  }

  oslo::middleware { 'barbican_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  # limit paging options
  barbican_config {
    'DEFAULT/max_limit_paging':     value => $max_limit_paging;
    'DEFAULT/default_limit_paging': value => $default_limit_paging;
  }
}
