# == Class: barbican::plugins::dogtag
#
# Sets up Barbican API dogtag secret_store and certificate plugin
#
# === Parameters
#
# [*dogtag_plugin_nss_password*]
#   (required) Password for plugin NSS DB
#
# [*dogtag_plugin_ensure_package*]
#   (optional) State of the dogtag client packages
#   Defaults to 'present'
#
# [*dogtag_plugin_pem_path*]
#   (optional) Path to KRA agent PEM file
#   Defaults to $facts['os_service_default']
#
# [*dogtag_plugin_dogtag_host*]
#   (optional) Host for the Dogtag server
#   Defaults to $facts['os_service_default']
#
# [*dogtag_plugin_dogtag_port*]
#   (optional) Host for the Dogtag server
#   Defaults to $facts['os_service_default']
#
# [*dogtag_plugin_nss_db_path*]
#   (optional) Path to plugin NSS DB
#   Defaults to $facts['os_service_default']
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
# DEPRECATED PARAMETERS
#
# [*dogtag_plugin_simple_cmc_profile*]
#   (optional) Profile for simple CMC enrollment.
#   Defaults to $facts['os_service_default']
#
# [*dogtag_plugin_ca_expiration_time*]
#   (optional) Expiration time for the Dogtag CA entry in days
#   Defaults to $facts['os_service_default']
#
# [*dogtag_plugin_plugin_working_dir*]
#   (optional) Working directory for Dogtag plugin
#   Defaults to $facts['os_service_default']
#
class barbican::plugins::dogtag (
  $dogtag_plugin_nss_password,
  $dogtag_plugin_ensure_package     = 'present',
  $dogtag_plugin_pem_path           = $facts['os_service_default'],
  $dogtag_plugin_dogtag_host        = $facts['os_service_default'],
  $dogtag_plugin_dogtag_port        = $facts['os_service_default'],
  $dogtag_plugin_nss_db_path        = $facts['os_service_default'],
  $global_default                   = false,
  # DEPRECATED PARAMETERS
  $dogtag_plugin_simple_cmc_profile = undef,
  $dogtag_plugin_ca_expiration_time = undef,
  $dogtag_plugin_plugin_working_dir = undef,
) {

  include barbican::deps
  include barbican::params

  [
    'simple_cmc_profile', 'ca_expiration_time', 'plugin_working_dir'
  ].each |String $opt| {
    if getvar("dogtag_plugin_${opt}") != undef {
      warning("The dogtag_plugin_${opt} parameter has been deprecated and has no effect")
    }
  }

  package {'dogtag-client':
    ensure => $dogtag_plugin_ensure_package,
    name   => $::barbican::params::dogtag_client_package,
    tag    => ['openstack', 'barbican-package']
  }

  barbican_config {
    'secretstore:dogtag/secret_store_plugin': value => 'dogtag_crypto';
    'secretstore:dogtag/global_default':      value => $global_default;
  }

  barbican_config {
    'dogtag_plugin/pem_path':     value => $dogtag_plugin_pem_path;
    'dogtag_plugin/dogtag_host':  value => $dogtag_plugin_dogtag_host;
    'dogtag_plugin/dogtag_port':  value => $dogtag_plugin_dogtag_port;
    'dogtag_plugin/nss_db_path':  value => $dogtag_plugin_nss_db_path;
    'dogtag_plugin/nss_password': value => $dogtag_plugin_nss_password, secret => true;
  }

  # TODO(tkajinam): Remove this after 2024.1 release
  barbican_config {
    'dogtag_plugin/simple_cmc_profile': ensure => absent;
    'dogtag_plugin/ca_expiration_time': ensure => absent;
    'dogtag_plugin/plugin_working_dir': ensure => absent;
  }
}
