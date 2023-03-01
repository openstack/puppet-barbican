# == Class: barbican::retry_scheduler
#
# Class to configure the retry scheduler service
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the barbican-retry package.
#   Defaults to 'present'
#
# [*manage_service*]
#   (Optional) If we should manage the barbican-retry service.
#   Defaults to true
#
# [*enabled*]
#   (Optional) Whether to enable the barbican-retry service.
#   Defaults to true
#
# [*initial_delay_seconds*]
#   (optional) Seconds (float) to wait before starting retry scheduler
#   Defaults to $facts['os_service_default']
#
# [*periodic_interval_max_seconds*]
#   (optional) Seconds (float) to wait between starting retry scheduler
#   Defaults to $facts['os_service_default']
#
class barbican::retry_scheduler (
  $package_ensure                = 'present',
  $manage_service                = true,
  $enabled                       = true,
  $initial_delay_seconds         = $facts['os_service_default'],
  $periodic_interval_max_seconds = $facts['os_service_default'],
){

  include barbican::deps
  include barbican::params

  barbican_config {
    'retry_scheduler/initial_delay_seconds':         value => $initial_delay_seconds;
    'retry_scheduler/periodic_interval_max_seconds': value => $periodic_interval_max_seconds;
  }

  case $facts['os']['family'] {
    'RedHat': {
      package { 'barbican-retry':
        ensure => $package_ensure,
        name   => $::barbican::params::retry_package_name,
        tag    => ['openstack', 'barbican-package'],
      }

      if $manage_service {
        if $enabled {
          $service_ensure = 'running'
        } else {
          $service_ensure = 'stopped'
        }

        service { 'barbican-retry':
          ensure     => $service_ensure,
          name       => $::barbican::params::retry_service_name,
          enable     => $enabled,
          hasstatus  => true,
          hasrestart => true,
          tag        => 'barbican-service',
        }
      }
    }
    default: {
      warning('barbican-retry package/service is not available')
    }
  }
}
