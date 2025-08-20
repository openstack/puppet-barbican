# == Class: barbican::plugins::simple_crypto
#
# Sets up Barbican simple_crypto plugin
#
# === Parameters
#
# [*simple_crypto_plugin_kek*]
#   (optional) Key encryption key to be used by Simple Crypto Plugin.
#   Defaults to $facts['os_service_default']
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
class barbican::plugins::simple_crypto (
  $simple_crypto_plugin_kek = $facts['os_service_default'],
  $global_default           = false,
) {
  include barbican::deps

  barbican_config {
    'secretstore:simple_crypto/secret_store_plugin': value => 'store_crypto';
    'secretstore:simple_crypto/crypto_plugin':       value => 'simple_crypto';
    'secretstore:simple_crypto/global_default':      value => $global_default;
  }

  barbican_config {
    'simple_crypto_plugin/kek': value => $simple_crypto_plugin_kek, secret => true;
  }
}
