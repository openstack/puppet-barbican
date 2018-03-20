#
# Class to execute barbican-db-manage upgrade
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the barbican-db-manage command.
#   Defaults to undef
#
# [*secret_store_extra_params*]
#   (optional) String of extra command line parameters to append
#   to the barbican-db-manage command.
#   Defaults to undef
#
class barbican::db::sync(
  $extra_params              = undef,
  $secret_store_extra_params = undef,
) {

  include ::barbican::deps

  exec { 'barbican-db-manage':
    command     => "barbican-manage db upgrade ${extra_params}",
    path        => ['/bin', '/usr/bin', ],
    user        => 'barbican',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
    user        => 'barbican',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
