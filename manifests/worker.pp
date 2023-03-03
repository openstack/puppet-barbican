#
# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: barbican::worker
#
# Manage the barbican-worker package and service.
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the barbican-worker package.
#   Defaults to 'present'
#
# [*manage_service*]
#   (Optional) If we should manage the barbican-worker service.
#   Defaults to true
#
# [*enabled*]
#   (Optional) Whether to enable the barbican-worker service.
#   Defaults to true
#
class barbican::worker (
  $package_ensure = 'present',
  $manage_service = true,
  $enabled        = true,
) inherits barbican::params {

  include barbican::deps

  validate_legacy(Boolean, 'validate_bool', $manage_service)
  validate_legacy(Boolean, 'validate_bool', $enabled)

  package { 'barbican-worker':
    ensure => $package_ensure,
    name   => $::barbican::params::worker_package_name,
    tag    => ['openstack', 'barbican-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'barbican-worker':
      ensure     => $service_ensure,
      name       => $::barbican::params::worker_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'barbican-service',
    }
  }
}
