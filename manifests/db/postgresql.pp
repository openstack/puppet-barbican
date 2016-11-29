# == Class: barbican::db::postgresql
#
# Class that configures postgresql for barbican
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'barbican'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'barbican'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class barbican::db::postgresql(
  $password,
  $dbname     = 'barbican',
  $user       = 'barbican',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::barbican::deps

  ::openstacklib::db::postgresql { 'barbican':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['barbican::db::begin']
  ~> Class['barbican::db::postgresql']
  ~> Anchor['barbican::db::end']

}
