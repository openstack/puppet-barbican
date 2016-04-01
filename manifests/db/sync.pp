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
  exec { 'barbican-db-manage':
    command     => "barbican-db-manage upgrade ${extra_params}",
    path        => '/usr/bin',
    user        => 'barbican',
    refreshonly => true,
    subscribe   => [Package['barbican-api'], Barbican_config['database/connection'], Barbican_config['DEFAULT/sql_connection'], ]
  }

  Exec['barbican-db-manage'] ~> Service<| title == 'barbican-api' |>
}
