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
#   Defaults to $barbican::params::api_service_name
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
  Stdlib::Ensure::Package $package_ensure = 'present',
  $bind_host                              = '0.0.0.0',
  $bind_port                              = '9311',
  $host_href                              = undef,
  $max_allowed_secret_in_bytes            = $facts['os_service_default'],
  $max_allowed_request_size_in_bytes      = $facts['os_service_default'],
  $enabled_secretstore_plugins            = $facts['os_service_default'],
  $enabled_crypto_plugins                 = $facts['os_service_default'],
  $enabled_secret_stores                  = 'simple_crypto',
  Boolean $multiple_secret_stores_enabled = false,
  $auth_strategy                          = 'keystone',
  Boolean $manage_service                 = true,
  Boolean $enabled                        = true,
  Boolean $sync_db                        = true,
  $db_auto_create                         = $facts['os_service_default'],
  $service_name                           = $barbican::params::api_service_name,
  $enable_proxy_headers_parsing           = $facts['os_service_default'],
  $max_request_body_size                  = $facts['os_service_default'],
  $max_limit_paging                       = $facts['os_service_default'],
  $default_limit_paging                   = $facts['os_service_default'],
) inherits barbican::params {
  include barbican::deps
  include barbican::db
  include barbican::policy

  package { 'barbican-api':
    ensure => $package_ensure,
    name   => $barbican::params::api_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

  # basic service config
  if $host_href == undef {
    $host_href_real = "http://${facts['networking']['fqdn']}:${bind_port}"
  } else {
    $host_href_real = $host_href
  }

  barbican_config {
    'DEFAULT/host_href': value => $host_href_real;
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
    'secretstore/enabled_secretstore_plugins': value => $enabled_secretstore_plugins;
    'crypto/enabled_crypto_plugins':           value => $enabled_crypto_plugins;
  }

  # enabled plugins when multiple plugins is enabled
  barbican_config {
    'secretstore/enable_multiple_secret_stores': value => $multiple_secret_stores_enabled;
    'secretstore/stores_lookup_suffix':          value => join(any2array($enabled_secret_stores), ',');
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

    if $service_name == $barbican::params::api_service_name {
      if $facts['os']['name'] == 'Ubuntu' {
        fail('With Ubuntu packages the service_name must be set to httpd as there is no eventlet init script.')
      }

      service { 'barbican-api':
        ensure     => $service_ensure,
        name       => $barbican::params::api_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'barbican-service',
      }

      # Debian is using UWSGI, not gunicorn
      if $facts['os']['name'] != 'Debian' {
        file_line { 'Modify bind_port in gunicorn-config.py':
          path    => '/etc/barbican/gunicorn-config.py',
          line    => "bind = '${bind_host}:${bind_port}'",
          match   => '^bind = .*',
          tag     => 'modify-bind-port',
          require => Anchor['barbican::config::begin'],
          before  => Anchor['barbican::config::end'],
          notify  => Service['barbican-api'],
        }
      }

      # On any paste-api.ini config change, we must restart Barbican API.
      Barbican_api_paste_ini<||> ~> Service['barbican-api']
      # On any uwsgi config change, we must restart Barbican API.
      Barbican_api_uwsgi_config<||> ~> Service['barbican-api']
    } elsif $service_name == 'httpd' {
      # Ubuntu packages does not have a barbican-api service
      if $facts['os']['name'] != 'Ubuntu' {
        service { 'barbican-api':
          ensure => 'stopped',
          name   => $barbican::params::api_service_name,
          enable => false,
          tag    => 'barbican-service',
        }

        # we need to make sure barbican-api is stopped before trying to start apache
        Service['barbican-api'] -> Service[$service_name]
      }

      Service <| title == 'httpd' |> { tag +> 'barbican-service' }
      # On any paste-api.ini config change, we must restart Barbican API.
      Barbican_api_paste_ini<||> ~> Service[$service_name]
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
