# == Class: barbican::plugins::vault
#
# Sets up Barbican vault plugin
#
# === Parameters
#
# [*vault_url*]
#   (optional) The Vault URL.
#   Defaults to $facts['os_service_default']
#
# [*root_token_id*]
#   (optional) Vault Root Token ID.
#   Defaults to $facts['os_service_default']
#
# [*approle_role_id*]
#   (optional) Set the approle role ID.
#   Defaults to $facts['os_service_default']
#
# [*approle_secret_id*]
#   (optional) Set the approle secret ID.
#   Defaults to $facts['os_service_default']
#
# [*kv_mountpoint*]
#   (optional) Set the mountpoint of the KV.
#   Defaults to $facts['os_service_default']
#
# [*use_ssl*]
#   (optional) Enable or disable SSL
#   Defaults to $facts['os_service_default']
#
# [*ssl_ca_crt_file*]
#   (optional) Set the ssl CA cert file
#   Defaults to $facts['os_service_default']
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
class barbican::plugins::vault (
  $vault_url         = $facts['os_service_default'],
  $root_token_id     = $facts['os_service_default'],
  $approle_role_id   = $facts['os_service_default'],
  $approle_secret_id = $facts['os_service_default'],
  $kv_mountpoint     = $facts['os_service_default'],
  $use_ssl           = $facts['os_service_default'],
  $ssl_ca_crt_file   = $facts['os_service_default'],
  $global_default    = false,
) {
  include barbican::deps

  barbican_config {
    'secretstore:vault/secret_store_plugin':  value => 'vault_plugin';
    'secretstore:vault/global_default':       value => $global_default;
    'vault_plugin/vault_url':                 value => $vault_url;
    'vault_plugin/root_token_id':             value => $root_token_id;
    'vault_plugin/approle_role_id':           value => $approle_role_id;
    'vault_plugin/approle_secret_id':         value => $approle_secret_id;
    'vault_plugin/kv_mountpoint':             value => $kv_mountpoint;
    'vault_plugin/use_ssl':                   value => $use_ssl;
    'vault_plugin/ssl_ca_crt_file':           value => $ssl_ca_crt_file;
  }
}
