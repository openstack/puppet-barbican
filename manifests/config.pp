# == Class: barbican::config
#
# This class is used to manage arbitrary barbican configurations.
#
# example xxx_config
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
# === Parameters
#
# [*barbican_config*]
# (optional) Allow configuration of barbican.conf configurations.
#
# [*api_paste_ini_config*]
# (optional) Allow configuration of barbican-api-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class barbican::config (
  Hash $barbican_config      = {},
  Hash $api_paste_ini_config = {},
) {

  include barbican::deps

  create_resources('barbican_config', $barbican_config)
  create_resources('barbican_api_paste_ini', $api_paste_ini_config)
}
