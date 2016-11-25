# == Class: barbican::keystone::notification
#
# Sets up keystone notifications for the Barbican API server
#
# === Parameters
#
# [*enable_keystone_notification*]
#   (optional) Enable keystone notification listener functionality
#   Defaults to $::os_service_default
#
# [*keystone_notification_control_exchange*]
#   (optional) The default exchange under which topics are scoped.
#   Defaults to $::os_service_default
#
# [*keystone_notification_topic*]
#   (optional) Keystone notification queue topic name.
#   Defaults to $::os_service_default
#
# [*keystone_notification_allow_requeue*]
#   (optional) Requeues notification in case of notification processing error.
#   Defaults to $::os_service_default
#
# [*keystone_notification_thread_pool_size*]
#   (optional) max threads to be used for notification server
#   Defaults to $::os_service_default
#
class barbican::keystone::notification (
  $enable_keystone_notification           = $::os_service_default,
  $keystone_notification_control_exchange = $::os_service_default,
  $keystone_notification_topic            = $::os_service_default,
  $keystone_notification_allow_requeue    = $::os_service_default,
  $keystone_notification_thread_pool_size = $::os_service_default,
) {

  include ::barbican::deps

  barbican_config {
    'keystone_notifications/enable':           value => $enable_keystone_notification;
    'keystone_notifications/control_exchange': value => $keystone_notification_control_exchange;
    'keystone_notifications/topic':            value => $keystone_notification_topic;
    'keystone_notifications/allow_requeue':    value => $keystone_notification_allow_requeue;
    'keystone_notifications/thread_pool_size': value => $keystone_notification_thread_pool_size;
  }
}
