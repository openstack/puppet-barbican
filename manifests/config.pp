# == Class: barbican::config
#
# This class is used to manage arbitrary barbican configurations.
#
# === Parameters
#
# [*xxx_config*]
#   (optional) Allow configuration of arbitrary barbican configurations.
#   The value is an hash of barbican_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   barbican_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*api_config*]
# (optional) Allow configuration of barbican-api.conf configurations.
#
# [*api_paste_ini_config*]
# (optional) Allow configuration of barbican-api-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class barbican::config (
  $api_config = {},
  $api_paste_ini_config = {},
) {

  include ::barbican::deps

  validate_hash($api_config)
  validate_hash($api_paste_ini_config)

  create_resources('barbican_config', $api_config)
  create_resources('barbican_api_paste_ini', $api_paste_ini_config)
}
