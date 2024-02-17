# == Class: barbican::deps
#
#  Barbican anchors and dependency management
#
class barbican::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'barbican::install::begin': }
  -> Package<| tag == 'barbican-package'|>
  ~> anchor { 'barbican::install::end': }
  -> anchor { 'barbican::config::begin': }
  -> Barbican_config<||>
  ~> anchor { 'barbican::config::end': }
  -> anchor { 'barbican::db::begin': }
  -> anchor { 'barbican::db::end': }
  ~> anchor { 'barbican::dbsync::begin': }
  -> anchor { 'barbican::dbsync::end': }
  ~> anchor { 'barbican::service::begin': }
  ~> Service<| tag == 'barbican-service' |>
  ~> anchor { 'barbican::service::end': }

  Anchor['barbican::config::begin']
  -> Barbican_api_paste_ini<||>
  -> Anchor['barbican::config::end']

  Anchor['barbican::config::begin']
  -> Barbican_api_uwsgi_config<||>
  -> Anchor['barbican::config::end']

  # Installation or config changes will always restart services.
  Anchor['barbican::install::end'] ~> Anchor['barbican::service::begin']
  Anchor['barbican::config::end']  ~> Anchor['barbican::service::begin']
}
