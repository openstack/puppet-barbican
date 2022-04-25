# == Class: barbican
#
# Barbican base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the cinder config.
#   Defaults to false.
#
class barbican(
  $package_ensure = 'present',
  $purge_config   = false,
) {

  include barbican::deps
  include barbican::params

  package { 'barbican':
    ensure => $package_ensure,
    name   => $::barbican::params::common_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

  resources { 'barbican_config':
    purge => $purge_config,
  }
}
