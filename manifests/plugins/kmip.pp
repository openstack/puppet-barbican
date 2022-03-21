# == Class: barbican::plugins::kmip
#
# Sets up Barbican API kmip secret_store plugin
#
# === Parameters
#
# [*kmip_plugin_host*]
#   (required) username for KMIP device
#
# [*kmip_plugin_port*]
#   (required) port for KMIP device
#
# [*kmip_plugin_username*]
#   (optional) username for KMIP device
#   Defaults to $::os_service_default
#
# [*kmip_plugin_password*]
#   (optional) password for KMIP device. This parameter is required
#   when the kmip_plugin_username parameter is set.
#   Defaults to $::os_service_default
#
# [*kmip_plugin_keyfile*]
#   (optional) key file for KMIP device. This parameter is required when
#   the kmip_plugin_username parameter is not set.
#   Defaults to $::os_service_default
#
# [*kmip_plugin_certfile*]
#   (optional) cert file for KMIP device. This parameter is required when
#   the kmip_plugin_username parameter is not set.
#   Defaults to $::os_service_default
#
# [*kmip_plugin_ca_certs*]
#   (optional) ca certs file for KMIP device. This parameter is required when
#   the kmip_plugin_username parameter is not set.
#   Defaults to $::os_service_default
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
class barbican::plugins::kmip (
  $kmip_plugin_host,
  $kmip_plugin_port,
  $kmip_plugin_username = $::os_service_default,
  $kmip_plugin_password = $::os_service_default,
  $kmip_plugin_keyfile  = $::os_service_default,
  $kmip_plugin_certfile = $::os_service_default,
  $kmip_plugin_ca_certs = $::os_service_default,
  $global_default       = false,
) {

  include barbican::deps

  if !is_service_default($kmip_plugin_username) {
    if is_service_default($kmip_plugin_password) {
      fail('kmip_plugin_password must be defined if kmip_plugin_username is defined')
    }
  } else {
    if is_service_default($kmip_plugin_certfile) {
      fail('kmip_plugin_certfile must be defined')
    }
    if is_service_default($kmip_plugin_keyfile) {
      fail('kmip_plugin_keyfile must be defined')
    }
    if is_service_default($kmip_plugin_ca_certs) {
      fail('kmip_plugin_ca_certs must be defined')
    }
  }

  barbican_config {
    'kmip_plugin/username': value => $kmip_plugin_username;
    'kmip_plugin/password': value => $kmip_plugin_password, secret => true;
    'kmip_plugin/keyfile':  value => $kmip_plugin_keyfile;
    'kmip_plugin/certfile': value => $kmip_plugin_certfile;
    'kmip_plugin/ca_certs': value => $kmip_plugin_ca_certs;
    'kmip_plugin/host':     value => $kmip_plugin_host;
    'kmip_plugin/port':     value => $kmip_plugin_port;
  }

  barbican_config {
    'secretstore:kmip/secret_store_plugin': value => 'kmip_plugin';
    'secretstore:kmip/global_default':      value => $global_default;
  }

}
