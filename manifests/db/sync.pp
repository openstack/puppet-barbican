#
# Class to execute barbican-db-manage upgrade
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the barbican-db-manage command.
#   Defaults to undef
#
# [*secret_store_extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the barbican-db-manage command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class barbican::db::sync(
  $extra_params              = undef,
  $secret_store_extra_params = undef,
  $db_sync_timeout           = 300,
) {

  include barbican::deps
  include barbican::params

  exec { 'barbican-db-manage':
    command     => "barbican-manage db upgrade ${extra_params}",
    path        => ['/bin', '/usr/bin', ],
    user        => $::barbican::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['barbican::install::end'],
      Anchor['barbican::config::end'],
      Anchor['barbican::dbsync::begin']
    ],
    notify      => Exec['barbican-db-manage sync secret stores'],
    tag         => 'openstack-db',
  }

  exec { 'barbican-db-manage sync secret stores':
    command     => "barbican-manage db sync_secret_stores ${secret_store_extra_params}",
    path        => ['/bin', '/usr/bin', ],
    user        => $::barbican::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['barbican::install::end'],
      Anchor['barbican::config::end'],
      Anchor['barbican::dbsync::begin']
    ],
    notify      => Anchor['barbican::dbsync::end'],
    tag         => 'openstack-db',
  }
}
