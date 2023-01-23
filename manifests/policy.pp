# == Class: barbican::policy
#
# Configure the barbican policies
#
# === Parameters
#
# [*enforce_scope*]
#  (Optional) Whether or not to enforce scope when evaluating policies.
#  Defaults to $::os_service_default.
#
# [*enforce_new_defaults*]
#  (Optional) Whether or not to use old deprecated defaults when evaluating
#  policies.
#  Defaults to $::os_service_default.
#
# [*policies*]
#   (Optional) Set of policies to configure for barbican
#   Example :
#     {
#       'barbican-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'barbican-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the barbican policy.yaml file
#   Defaults to /etc/barbican/policy.yaml
#
# [*policy_default_rule*]
#   (Optional) Default rule. Enforced when a requested rule is not found.
#   Defaults to $::os_service_default.
#
# [*policy_dirs*]
#   (Optional) Path to the barbican policy folder
#   Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified policy rules in the policy
#    file.
#    Defaults to false.
#
class barbican::policy (
  $enforce_scope        = $::os_service_default,
  $enforce_new_defaults = $::os_service_default,
  $policies             = {},
  $policy_path          = '/etc/barbican/policy.yaml',
  $policy_default_rule  = $::os_service_default,
  $policy_dirs          = $::os_service_default,
  $purge_config         = false,
) {

  include barbican::deps
  include barbican::params

  validate_legacy(Hash, 'validate_hash', $policies)

  $policy_parameters = {
    policies     => $policies,
    policy_path  => $policy_path,
    file_user    => 'root',
    file_group   => $::barbican::params::group,
    file_format  => 'yaml',
    purge_config => $purge_config,
  }

  create_resources('openstacklib::policy', { $policy_path => $policy_parameters })

  oslo::policy { 'barbican_config':
    enforce_scope        => $enforce_scope,
    enforce_new_defaults => $enforce_new_defaults,
    policy_file          => $policy_path,
    policy_default_rule  => $policy_default_rule,
    policy_dirs          => $policy_dirs,
  }

}
