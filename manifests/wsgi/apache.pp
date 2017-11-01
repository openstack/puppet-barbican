#
# Class to serve barbican with apache mod_wsgi in place of barbican service
#
# Serving barbican from apache is the recommended way to go for production
# systems as the current barbican implementation is not multi-processor aware,
# thus limiting the performance for concurrent accesses.
#
# When using this class you should disable your barbican service.
#
# == Parameters
#
#   [*servername*]
#     The servername for the virtualhost.
#     Optional. Defaults to $::fqdn
#
#   [*public_port*]
#     The public port.
#     Optional. Defaults to 9311
#
#   [*bind_host*]
#     The host/ip address Apache will listen on.
#     Optional. Defaults to undef (listen on all ip addresses).
#
#   [*public_path*]
#     The prefix for the public endpoint.
#     Optional. Defaults to '/'
#
#   [*ssl*]
#     Use ssl ? (boolean)
#     Optional. Defaults to true
#
#   [*workers*]
#     Number of WSGI workers to spawn.
#     Optional. Defaults to $::os_workers
#
#   [*ssl_cert*]
#     (optional) Path to SSL certificate
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_key*]
#     (optional) Path to SSL key
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_chain*]
#     (optional) SSL chain
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_ca*]
#     (optional) Path to SSL certificate authority
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_crl_path*]
#     (optional) Path to SSL certificate revocation list
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_crl*]
#     (optional) SSL certificate revocation list name
#     Default to apache::vhost 'ssl_*' defaults.
#
#   [*ssl_certs_dir*]
#     apache::vhost ssl parameters.
#     Optional. Default to apache::vhost 'ssl_*' defaults.
#
#   [*priority*]
#     (optional) The priority for the vhost.
#     Defaults to '10'
#
#   [*threads*]
#     (optional) The number of threads for the vhost.
#     Defaults to 1
#
#   [*wsgi_process_display_name*]
#     (optional) Name of the WSGI process display-name.
#     Defaults to undef
#
#   [*access_log_file*]
#     The log file name for the virtualhost.
#     Optional. Defaults to false.
#
#   [*access_log_format*]
#     The log format for the virtualhost.
#     Optional. Defaults to false.
#
#   [*error_log_file*]
#     The error log file name for the virtualhost.
#     Optional. Defaults to undef.
#
# [*custom_wsgi_process_options*]
#   (optional) gives you the oportunity to add custom process options or to
#   overwrite the default options for the WSGI main process.
#   eg. to use a virtual python environment for the WSGI process
#   you could set it to:
#   { python-path => '/my/python/virtualenv' }
#   Defaults to {}
#
# == Dependencies
#
#   requires Class['apache'] & Class['barbican']
#
# == Examples
#
#   include apache
#
#   class { 'barbican::wsgi::apache': }
#
# == Authors
#
#   Ade Lee <alee@redhat.com>
#
# == Copyright
#
#   Copyright 2015 Red Hat Inc. <licensing@redhat.com>
#
class barbican::wsgi::apache (
  $servername                  = $::fqdn,
  $public_port                 = 9311,
  $bind_host                   = undef,
  $public_path                 = '/',
  $ssl                         = true,
  $workers                     = $::os_workers,
  $ssl_cert                    = undef,
  $ssl_key                     = undef,
  $ssl_chain                   = undef,
  $ssl_ca                      = undef,
  $ssl_crl_path                = undef,
  $ssl_crl                     = undef,
  $ssl_certs_dir               = undef,
  $wsgi_process_display_name   = undef,
  $threads                     = 1,
  $priority                    = '10',
  $access_log_file             = false,
  $access_log_format           = false,
  $error_log_file              = undef,
  $custom_wsgi_process_options = {},
) {

  include ::barbican::deps
  include ::barbican::params
  include ::apache
  include ::apache::mod::wsgi
  if $ssl {
    include ::apache::mod::ssl
  }

  Service['httpd'] -> Keystone_endpoint <| |>
  Service['httpd'] -> Keystone_role <| |>
  Service['httpd'] -> Keystone_service <| |>
  Service['httpd'] -> Keystone_tenant <| |>
  Service['httpd'] -> Keystone_user <| |>
  Service['httpd'] -> Keystone_user_role <| |>

  file { $::barbican::params::httpd_config_file:
    ensure  => present,
    content => "#
# This file has been cleaned by Puppet.
#
# OpenStack Horizon configuration has been moved to:
# - ${priority}-barbican_wsgi_main.conf
#",
  }

  Package<| tag == 'barbican-api' |> -> File[$::barbican::params::httpd_config_file]
  File[$::barbican::params::httpd_config_file] ~> Service['httpd']

  ::openstacklib::wsgi::apache { 'barbican_wsgi_main':
    bind_host                   => $bind_host,
    bind_port                   => $public_port,
    group                       => 'barbican',
    path                        => $public_path,
    priority                    => $priority,
    servername                  => $servername,
    ssl                         => $ssl,
    ssl_ca                      => $ssl_ca,
    ssl_cert                    => $ssl_cert,
    ssl_certs_dir               => $ssl_certs_dir,
    ssl_chain                   => $ssl_chain,
    ssl_crl                     => $ssl_crl,
    ssl_crl_path                => $ssl_crl_path,
    ssl_key                     => $ssl_key,
    threads                     => $threads,
    user                        => 'barbican',
    workers                     => $workers,
    wsgi_daemon_process         => 'barbican-api',
    wsgi_process_display_name   => $wsgi_process_display_name,
    wsgi_process_group          => 'barbican-api',
    wsgi_script_dir             => $::barbican::params::barbican_wsgi_script_path,
    wsgi_script_file            => 'main',
    wsgi_script_source          => $::barbican::params::barbican_wsgi_script_source,
    access_log_file             => $access_log_file,
    access_log_format           => $access_log_format,
    error_log_file              => $error_log_file,
    custom_wsgi_process_options => $custom_wsgi_process_options,
  }
}
