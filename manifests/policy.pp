# == Class: barbican::policy
#
# Configure the barbican policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for barbican
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
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/barbican/policy.json
#
class barbican::policy (
  $policies    = {},
  $policy_path = '/etc/barbican/policy.json',
) {

  include ::barbican::deps
  include ::barbican::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::barbican::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'barbican_config': policy_file => $policy_path }

}
