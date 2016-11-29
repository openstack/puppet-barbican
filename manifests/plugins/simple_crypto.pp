# == Class: barbican::plugins::simple_crypto
#
# Sets up Barbican simple_crypto plugin
#
# === Parameters
#
# [*simple_crypto_plugin_kek*]
#   (optional) base64 encoded 32-byte value
#   Defaults to $::os_service_default
#
class barbican::plugins::simple_crypto (
  $simple_crypto_plugin_kek = $::os_service_default,
) {

  include ::barbican::deps

  barbican_config {
    'simple_crypto_plugin/kek':  value => $simple_crypto_plugin_kek;
  }
}
