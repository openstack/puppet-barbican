# == Class: barbican::keystone::auth
#
# Configures barbican user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for barbican user.
#
# [*auth_name*]
#   (Optional) Username for barbican service.
#   Defaults to 'barbican'.
#
# [*email*]
#   (Optional) Email for barbican user.
#   Defaults to 'barbican@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for barbican user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to barbican user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to barbican user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should barbican endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*configure_service*]
#   (Optional) Should the service be configured?
#   Defaults to True
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'key-manager'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'barbican'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'OpenStack Key Manager Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9311'.
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9311'.
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9311'.
#
class barbican::keystone::auth (
  String[1] $password,
  String[1] $auth_name                    = 'barbican',
  String[1] $email                        = 'barbican@localhost',
  String[1] $tenant                       = 'services',
  Array[String[1]] $roles                 = ['admin'],
  String[1] $system_scope                 = 'all',
  Array[String[1]] $system_roles          = [],
  Boolean $configure_endpoint             = true,
  Boolean $configure_user                 = true,
  Boolean $configure_user_role            = true,
  Boolean $configure_service              = true,
  String[1] $service_description          = 'OpenStack Key Manager Service',
  String[1] $service_name                 = 'barbican',
  String[1] $service_type                 = 'key-manager',
  String[1] $region                       = 'RegionOne',
  Keystone::PublicEndpointUrl $public_url = 'http://127.0.0.1:9311',
  Keystone::EndpointUrl $internal_url     = 'http://127.0.0.1:9311',
  Keystone::EndpointUrl $admin_url        = 'http://127.0.0.1:9311',
) {
  include barbican::deps

  Keystone::Resource::Service_identity['barbican'] -> Anchor['barbican::service::end']

  keystone::resource::service_identity { 'barbican':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    configure_service   => $configure_service,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }
}
