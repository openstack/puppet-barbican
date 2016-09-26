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
#     Optional. Defaults to 1
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
#     Defaults to $::processorcount
#
#   [*wsgi_script_ensure*]
#     (optional) File ensure parameter for wsgi scripts.
#     Defaults to 'file'.
#
#   [*wsgi_script_source*]
#     (optional) Wsgi script source.
#     Defaults to undef.
#
#   [*wsgi_application_group*]
#     (optional) The application group of the WSGI script.
#     Defaults to '%{GLOBAL}'
#
#   [*wsgi_pass_authorization*]
#     (optional) Whether HTTP authorisation headers are passed through to a WSGI
#     script when the equivalent HTTP request headers are present.
#     Defaults to 'On'
#
#   [*access_log_format*]
#     The log format for the virtualhost.
#     Optional. Defaults to false.
#
#   [*vhost_custom_fragment*]
#     (optional) Passes a string of custom configuration
#     directives to be placed at the end of the vhost configuration.
#     Defaults to undef.
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
  $servername              = $::fqdn,
  $public_port             = 9311,
  $bind_host               = undef,
  $public_path             = '/',
  $ssl                     = true,
  $workers                 = 1,
  $ssl_cert                = undef,
  $ssl_key                 = undef,
  $ssl_chain               = undef,
  $ssl_ca                  = undef,
  $ssl_crl_path            = undef,
  $ssl_crl                 = undef,
  $ssl_certs_dir           = undef,
  $threads                 = $::processorcount,
  $priority                = '10',
  $wsgi_script_ensure      = 'file',
  $wsgi_script_source      = undef,
  $wsgi_application_group  = '%{GLOBAL}',
  $wsgi_pass_authorization = 'On',

  $access_log_format     = false,
  $vhost_custom_fragment = undef,
) {

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

  ## Sanitize parameters

  # Ensure there's no trailing '/' except if this is also the only character
  $public_path_real = regsubst($public_path, '(^/.*)/$', '\1')

  file { $::barbican::params::barbican_wsgi_script_path:
    ensure  => directory,
    owner   => 'barbican',
    group   => 'barbican',
    require => Package['httpd'],
  }

  Package<| tag == 'barbican-api' |> -> File[$::barbican::params::barbican_wsgi_script_path]

  $wsgi_files = {
    'barbican_wsgi_main'  => {
      'path' => "${::barbican::params::barbican_wsgi_script_path}/main",
    },
  }

  $wsgi_file_defaults = {
    'ensure'  => $wsgi_script_ensure,
    'owner'   => 'barbican',
    'group'   => 'barbican',
    'mode'    => '0644',
    'require' => [File[$::barbican::params::barbican_wsgi_script_path], Package['barbican-api']],
  }

  $wsgi_script_source_real = $wsgi_script_source ? {
    default => $wsgi_script_source,
    undef   => $::barbican::params::barbican_wsgi_script_source,
  }

  case $wsgi_script_ensure {
    'link':  { $wsgi_file_source = { 'target' => $wsgi_script_source_real } }
    default: { $wsgi_file_source = { 'source' => $wsgi_script_source_real } }
  }

  create_resources('file', $wsgi_files, merge($wsgi_file_defaults, $wsgi_file_source))

  $wsgi_daemon_process_options_main = {
    user         => 'barbican',
    group        => 'barbican',
    processes    => $workers,
    threads      => $threads,
    display-name => 'barbican-api',
  }

  $wsgi_script_aliases_main = hash([$public_path_real,"${::barbican::params::barbican_wsgi_script_path}/main"])
  $wsgi_script_aliases_main_real = $wsgi_script_aliases_main

  ::apache::vhost { 'barbican_wsgi_main':
    ensure                      => 'present',
    servername                  => $servername,
    ip                          => $bind_host,
    port                        => $public_port,
    docroot                     => $::barbican::params::barbican_wsgi_script_path,
    docroot_owner               => 'barbican',
    docroot_group               => 'barbican',
    priority                    => $priority,
    ssl                         => $ssl,
    ssl_cert                    => $ssl_cert,
    ssl_key                     => $ssl_key,
    ssl_chain                   => $ssl_chain,
    ssl_ca                      => $ssl_ca,
    ssl_crl_path                => $ssl_crl_path,
    ssl_crl                     => $ssl_crl,
    ssl_certs_dir               => $ssl_certs_dir,
    wsgi_daemon_process         => 'barbican-api',
    wsgi_daemon_process_options => $wsgi_daemon_process_options_main,
    wsgi_process_group          => 'barbican-api',
    wsgi_script_aliases         => $wsgi_script_aliases_main_real,
    wsgi_application_group      => $wsgi_application_group,
    wsgi_pass_authorization     => $wsgi_pass_authorization,
    custom_fragment             => $vhost_custom_fragment,
    require                     => File['barbican_wsgi_main'],
    access_log_format           => $access_log_format,
    log_level                   => 'debug',
  }
}
