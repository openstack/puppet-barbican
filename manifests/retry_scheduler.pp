# == Class: barbican::retry_scheduler
#
# Class to configure the retry scheduler service
#
# === Parameters
#
# [*initial_delay_seconds*]
#   (optional) Seconds (float) to wait before starting retry scheduler
#   Defaults to $::os_service_default
#
# [*periodic_interval_max_seconds*]
#   (optional) Seconds (float) to wait between starting retry scheduler
#   Defaults to $::os_service_default
#
class barbican::retry_scheduler (
  $initial_delay_seconds         = $::os_service_default,
  $periodic_interval_max_seconds = $::os_service_default,
){

  include barbican::params

  barbican_config {
    'retry_scheduler/initial_delay_seconds':         value => $initial_delay_seconds;
    'retry_scheduler/periodic_interval_max_seconds': value => $periodic_interval_max_seconds;
  }

  # TODO(tkajinam): Currently NO DISTRO provides the pachage to install
  #                 the retry daemon service. Once that is fixed, install
  #                 a separate package and enable the service.
}
