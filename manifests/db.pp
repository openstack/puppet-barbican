# == Class: barbican::db
#
#  Configure the barbican database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to "sqlite:////var/lib/barbican/barbican.sqlite".
#
# [*database_connection_recycle_time*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_retries*]
#   Maximum number of database connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   NOTE: This is currently NOT used until barbican correctly leverages oslo.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_retry_interval*]
#   Interval between retries of opening a database connection.
#   NOTE: This is currently NOT used until barbican correctly leverages oslo.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   NOTE: This is currently NOT used until barbican correctly leverages oslo.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_pool_size*]
#   Number of SQL connections to keep open in a pool.
#   NOTE: This is currently used until barbican correctly leverages oslo and
#   will be removed during a later release.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_db_max_retries*]
#   (Optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $facts['os_service_default']
#
# [*mysql_enable_ndb*]
#   (Optional) If True, transparently enables support for handling MySQL
#   Cluster (NDB).
#   Defaults to $facts['os_service_default']
#
class barbican::db (
  $database_connection              = 'sqlite:////var/lib/barbican/barbican.sqlite',
  $database_connection_recycle_time = $facts['os_service_default'],
  $database_max_pool_size           = $facts['os_service_default'],
  $database_max_retries             = $facts['os_service_default'],
  $database_retry_interval          = $facts['os_service_default'],
  $database_max_overflow            = $facts['os_service_default'],
  $database_pool_size               = $facts['os_service_default'],
  $database_db_max_retries          = $facts['os_service_default'],
  $database_pool_timeout            = $facts['os_service_default'],
  $mysql_enable_ndb                 = $facts['os_service_default'],
) {

  include barbican::deps

  oslo::db { 'barbican_config':
    connection              => $database_connection,
    connection_recycle_time => $database_connection_recycle_time,
    max_pool_size           => $database_max_pool_size,
    max_retries             => $database_max_retries,
    retry_interval          => $database_retry_interval,
    max_overflow            => $database_max_overflow,
    db_max_retries          => $database_db_max_retries,
    pool_timeout            => $database_pool_timeout,
    mysql_enable_ndb        => $mysql_enable_ndb,
  }

  # TODO(aschultz): Remove this config once barbican properly leverages oslo
  barbican_config {
    'DEFAULT/sql_connection':        value => $database_connection, secret => true;
    'DEFAULT/sql_idle_timeout':      value => $database_connection_recycle_time;
    'DEFAULT/sql_pool_size':         value => $database_pool_size;
    'DEFAULT/sql_pool_max_overflow': value => $database_max_overflow;
  }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db['barbican_config'] -> Anchor['barbican::dbsync::begin']
}
