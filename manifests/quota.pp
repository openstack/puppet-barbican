# == Class: barbican::quota
#
# Sets up Barbican API server quotas
#
# === Parameters
#
# [*quota_secrets*]
#   (optional) default number of secrets allowed per project
#   Defaults to $::os_service_default
#
# [*quota_orders*]
#   (optional) default number of orders allowed per project
#   Defaults to $::os_service_default
#
# [*quota_containers*]
#   (optional) default number of containers allowed per project
#   Defaults to $::os_service_default
#
# [*quota_consumers*]
#   (optional) default number of consumers allowed per project
#   Defaults to $::os_service_default
#
# [*quota_cas*]
#   (optional) default number of CAs allowed per project
#   Defaults to $::os_service_default
#
class barbican::quota (
  $quota_secrets     = $::os_service_default,
  $quota_orders      = $::os_service_default,
  $quota_containers  = $::os_service_default,
  $quota_consumers   = $::os_service_default,
  $quota_cas         = $::os_service_default,
) {

  include ::barbican::deps

  barbican_config {
    'quotas/quota_secrets':      value => $quota_secrets;
    'quotas/quota_orders':       value => $quota_orders;
    'quotas/quota_containers':   value => $quota_containers;
    'quotas/quota_consumers':    value => $quota_consumers;
    'quotas/quota_cas':          value => $quota_cas;
  }
}
