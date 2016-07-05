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
    command     => "barbican-manage db upgrade ${extra_params}",
    path        => '/usr/bin',
    user        => 'barbican',
    refreshonly => true,
  }

  Barbican_config <| title == 'database/connection' |> ~> Exec['barbican-db-manage']
  Barbican_config <| title == 'DEFAULT/sql_connection' |> ~> Exec['barbican-db-manage']
  Package <| tag == 'barbican-package' |> ~> Exec['barbican-db-manage']
  Package <| tag == 'openstack' |> -> Exec['barbican-db-manage']
  Exec['barbican-db-manage'] ~> Service<| title == 'barbican-api' |>
}
