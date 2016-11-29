# == Class: barbican::keystone::auth
#
# Configures barbican user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for barbican user.
#
# [*auth_name*]
#   Username for barbican service. Defaults to 'barbican'.
#
# [*email*]
#   Email for barbican user. Defaults to 'barbican@localhost'.
#
# [*tenant*]
#   Tenant for barbican user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should barbican endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'key-manager'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'barbican'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9311')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9311')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9311')
#   This url should *not* contain any trailing '/'.
#
class barbican::keystone::auth (
  $password,
  $auth_name           = 'barbican',
  $email               = 'barbican@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'barbican',
  $service_type        = 'key-manager',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9311',
  $internal_url        = 'http://127.0.0.1:9311',
  $admin_url           = 'http://127.0.0.1:9311',
) {

  include ::barbican::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['barbican::service::end']
  }
  Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Anchor['barbican::service::end']

  keystone::resource::service_identity { 'barbican':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => 'Key management Service',
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
