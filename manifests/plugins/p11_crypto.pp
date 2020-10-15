# == Class: barbican::plugins::p11_crypto
#
# Sets up Barbican API p11_crypto secret_store plugin
#
# === Parameters
#
# [*p11_crypto_plugin_library_path*]
#   (optional) Path to vendor PKCS11 library
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_login*]
#   (optional) Password to login to PKCS11 session
#   Required if p11_crypto_plugin is enabled.
#   Defaults to undef
#
# [*p11_crypto_plugin_mkek_label*]
#   (optional) Label to identify master KEK in the HSM
#   Required if p11_crypto_plugin is enabled.
#   Defaults to undef
#
# [*p11_crypto_plugin_mkek_length*]
#   (optional) Length in bytes of master KEK
#   Required if p11_crypto_plugin is enabled.
#   Defaults to undef
#
# [*p11_crypto_plugin_hmac_label*]
#   (optional) Label to identify master KEK in the HSM
#   Required if p11_crypto_plugin is enabled.
#   Defaults to undef
#
# [*p11_crypto_plugin_token_serial_number*]
#   (optional) Serial number to identify PKCS#11 token
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_token_label*]
#   (optional) Label to identify PKCS#11 token
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_slot_id*]
#   (optional) HSM Slot id
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_encryption_mechanism*]
#   (optional) PKCS#11 Mechanism used for encryption
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_hmac_key_type*]
#   (optional) PKCS#11 Key Type for key used in HMAC
#   operations.
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_hmac_keygen_mechanism*]
#   (optional) PKCS#11 Mechanism used to generate HMAC Key
#   Defaults to $::os_service_default
#
# [*p11_crypto_plugin_aes_gcm_generate_iv*]
#   (optional) When using the CKM_AES_GCM mechanism, this option
#   specifies whether the IV should be generated by Barbican.
#   Setting this to false will defer IV generation to the HSM
#   which is not standard but is required for some HSMs.
#   Defaults to $::os_service_default
#
# [*global_default*]
#   (optional) set plugin as global default
#   Defaults to false
#
class barbican::plugins::p11_crypto (
  $p11_crypto_plugin_library_path          = undef,
  $p11_crypto_plugin_login                 = undef,
  $p11_crypto_plugin_mkek_label            = undef,
  $p11_crypto_plugin_mkek_length           = undef,
  $p11_crypto_plugin_hmac_label            = undef,
  $p11_crypto_plugin_token_serial_number   = $::os_service_default,
  $p11_crypto_plugin_token_label           = $::os_service_default,
  $p11_crypto_plugin_slot_id               = $::os_service_default,
  $p11_crypto_plugin_encryption_mechanism  = $::os_service_default,
  $p11_crypto_plugin_hmac_key_type         = $::os_service_default,
  $p11_crypto_plugin_hmac_keygen_mechanism = $::os_service_default,
  $p11_crypto_plugin_aes_gcm_generate_iv   = $::os_service_default,
  $global_default                          = false,
) {

  include ::barbican::deps

  if $p11_crypto_plugin_library_path == undef {
      fail('p11_crypto_plugin_library_path must be defined')
  }
  if $p11_crypto_plugin_login == undef {
      fail('p11_crypto_plugin_login must be defined')
  }
  if $p11_crypto_plugin_mkek_label == undef {
      fail('p11_crypto_plugin_mkek_label must be defined')
  }
  if $p11_crypto_plugin_mkek_length == undef {
      fail('p11_crypto_plugin_mkek_length must be defined')
  }
  if $p11_crypto_plugin_hmac_label == undef {
      fail('p11_crypto_plugin_hmac_label must be defined')
  }

  barbican_config {
    'p11_crypto_plugin/library_path':          value => $p11_crypto_plugin_library_path;
    'p11_crypto_plugin/login':                 value => $p11_crypto_plugin_login;
    'p11_crypto_plugin/mkek_label':            value => $p11_crypto_plugin_mkek_label;
    'p11_crypto_plugin/mkek_length':           value => $p11_crypto_plugin_mkek_length;
    'p11_crypto_plugin/hmac_label':            value => $p11_crypto_plugin_hmac_label;
    'p11_crypto_plugin/token_serial_number':   value => $p11_crypto_plugin_token_serial_number;
    'p11_crypto_plugin/token_label':           value => $p11_crypto_plugin_token_label;
    'p11_crypto_plugin/slot_id':               value => $p11_crypto_plugin_slot_id;
    'p11_crypto_plugin/encryption_mechanism':  value => $p11_crypto_plugin_encryption_mechanism;
    'p11_crypto_plugin/hmac_key_type':         value => $p11_crypto_plugin_hmac_key_type;
    'p11_crypto_plugin/hmac_keygen_mechanism': value => $p11_crypto_plugin_hmac_keygen_mechanism;
    'p11_crypto_plugin/aes_gcm_generate_iv':   value => $p11_crypto_plugin_aes_gcm_generate_iv;
  }

  barbican_config {
    'secretstore:pkcs11/secret_store_plugin': value => 'store_crypto';
    'secretstore:pkcs11/crypto_plugin':       value => 'p11_crypto';
    'secretstore:pkcs11/global_default':      value => $global_default;
  }
}
