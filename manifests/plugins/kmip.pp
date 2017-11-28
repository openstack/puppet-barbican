# == Class: barbican::plugins::kmip
#
# Sets up Barbican API kmip secret_store plugin
#
# === Parameters
#
# [*kmip_plugin_username*]
#   (optional) username for KMIP device
#   Required if kmip_plugin is enabled.
#   Defaults to undef
#
# [*kmip_plugin_password*]
#   (optional) password for KMIP device
#   Required if kmip_plugin is enabled.
#   Defaults to undef
#
# [*kmip_plugin_host*]
#   (optional) username for KMIP device
#   Defaults to undef
#
# [*kmip_plugin_port*]
#   (optional) port for KMIP device
#   Defaults to undef
#
# [*kmip_plugin_keyfile*]
#   (optional) key file for KMIP device
#   Defaults to undef
#
# [*kmip_plugin_certfile*]
#   (optional) cert file for KMIP device
#   Defaults to undef
#
# [*kmip_plugin_ca_certs*]
#   (optional) ca certs file for KMIP device
#   Defaults to undef
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
class barbican::plugins::kmip (
  $kmip_plugin_username = undef,
  $kmip_plugin_password = undef,
  $kmip_plugin_host     = undef,
  $kmip_plugin_port     = undef,
  $kmip_plugin_keyfile  = undef,
  $kmip_plugin_certfile = undef,
  $kmip_plugin_ca_certs = undef,
  $global_default       = false,
) {

  include ::barbican::deps

  if $kmip_plugin_host == undef {
    fail('kmip_plugin_host must be defined')
  }
  if $kmip_plugin_port == undef {
    fail('kmip_plugin_port must be defined')
  }
  if $kmip_plugin_username != undef {
    if $kmip_plugin_password == undef {
      fail('kmip_plugin_password must be defined if kmip_plugin_username is defined')
    }
  } else {
    if $kmip_plugin_certfile == undef {
      fail('kmip_plugin_certfile must be defined')
    }
    if $kmip_plugin_keyfile == undef {
      fail('kmip_plugin_keyfile must be defined')
    }
    if $kmip_plugin_ca_certs == undef {
      fail('kmip_plugin_ca_certs must be defined')
    }
  }

  if $kmip_plugin_username != undef {
    barbican_config {
      'kmip_plugin/username': value => $kmip_plugin_username;
      'kmip_plugin/password': value => $kmip_plugin_password, secret => true;
      'kmip_plugin/host':     value => $kmip_plugin_host;
      'kmip_plugin/port':     value => $kmip_plugin_port;
    }
  } else {
    barbican_config {
      'kmip_plugin/keyfile':  value => $kmip_plugin_keyfile;
      'kmip_plugin/certfile': value => $kmip_plugin_certfile;
      'kmip_plugin/ca_certs': value => $kmip_plugin_ca_certs;
      'kmip_plugin/host':     value => $kmip_plugin_host;
      'kmip_plugin/port':     value => $kmip_plugin_port;
    }
  }

  barbican_config {
    'secretstore:kmip/secret_store_plugin': value => 'kmip_plugin';
    'secretstore:kmip/global_default':      value => $global_default;
  }

}
