# == Class: barbican::config
#
# This class is used to manage arbitrary barbican configurations.
#
# === Parameters
#
# [*barbican_config*]
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
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class barbican::config (
  $barbican_config = {},
) {

  validate_hash($barbican_config)

  create_resources('barbican_config', $barbican_config)
}
