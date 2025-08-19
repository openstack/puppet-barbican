# == Class: barbican::keystone::notification
#
# Sets up keystone notifications for the Barbican API server
#
# === Parameters
#
# [*enable_keystone_notification*]
#   (optional) Enable keystone notification listener functionality
#   Defaults to $facts['os_service_default']
#
# [*keystone_notification_control_exchange*]
#   (optional) The default exchange under which topics are scoped.
#   Defaults to $facts['os_service_default']
#
# [*keystone_notification_topic*]
#   (optional) Keystone notification queue topic name.
#   Defaults to $facts['os_service_default']
#
# [*keystone_notification_allow_requeue*]
#   (optional) Requeues notification in case of notification processing error.
#   Defaults to $facts['os_service_default']
#
# [*keystone_notification_thread_pool_size*]
#   (optional) max threads to be used for notification server
#   Defaults to $facts['os_service_default']
#
# [*package_ensure*]
#   (Optional) The state of the barbican-keystone-listener package.
#   Defaults to 'present'
#
# [*manage_service*]
#   (Optional) If we should manage the barbican-keystone-listener service.
#   Defaults to true
#
class barbican::keystone::notification (
  $enable_keystone_notification           = $facts['os_service_default'],
  $keystone_notification_control_exchange = $facts['os_service_default'],
  $keystone_notification_topic            = $facts['os_service_default'],
  $keystone_notification_allow_requeue    = $facts['os_service_default'],
  $keystone_notification_thread_pool_size = $facts['os_service_default'],
  $package_ensure                         = 'present',
  Boolean $manage_service                 = true,
) {
  include barbican::deps
  include barbican::params

  barbican_config {
    'keystone_notifications/enable':           value => $enable_keystone_notification;
    'keystone_notifications/control_exchange': value => $keystone_notification_control_exchange;
    'keystone_notifications/topic':            value => $keystone_notification_topic;
    'keystone_notifications/allow_requeue':    value => $keystone_notification_allow_requeue;
    'keystone_notifications/thread_pool_size': value => $keystone_notification_thread_pool_size;
  }

  package { 'barbican-keystone-listener':
    ensure => $package_ensure,
    name   => $barbican::params::keystone_listener_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

  if is_service_default($enable_keystone_notification) {
    $service_enabled = false
  } else {
    $service_enabled = Boolean($enable_keystone_notification)
  }

  if $manage_service {
    if $service_enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'barbican-keystone-listener':
      ensure     => $service_ensure,
      name       => $barbican::params::keystone_listener_service_name,
      enable     => $service_enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'barbican-service',
    }
  }
}
