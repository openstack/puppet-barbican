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
class barbican::db::sync(
  $extra_params  = undef,
) {

  include ::barbican::deps

  exec { 'barbican-db-manage':
    command     => "barbican-manage db upgrade ${extra_params}",
    path        => ['/bin', '/usr/bin', ],
    user        => 'barbican',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [
      Anchor['barbican::install::end'],
      Anchor['barbican::config::end'],
      Anchor['barbican::dbsync::begin']
    ],
    notify      => Anchor['barbican::dbsync::end'],
  }

}
