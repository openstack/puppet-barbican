# The barbican::db::mysql class implements mysql backend for barbican
#
# This class can be used to create tables, users and grant
# privileges for a mysql barbican database.
#
# == Parameters
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
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
class barbican::db::mysql(
  $password,
  $dbname        = 'barbican',
  $user          = 'barbican',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include barbican::deps

  validate_legacy(String, 'validate_string', $password)

  openstacklib::db::mysql { 'barbican':
    user          => $user,
    password      => $password,
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['barbican::db::begin']
  ~> Class['barbican::db::mysql']
  ~> Anchor['barbican::db::end']
}
