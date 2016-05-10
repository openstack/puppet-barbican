require 'spec_helper_acceptance'
describe 'barbican::api class' do
  context 'default parameters' do
    pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql

      case $::osfamily {
        'Debian': {
          warning('Barbican is not yet packaged on Ubuntu systems.')
        }
        'RedHat': {
          # Barbican resources
          include ::barbican

          class { '::barbican::api::logging':
            verbose => true,
          }

          class { '::barbican::quota':
          }

          class { '::barbican::keystone::notification':
          }

          class { '::barbican::api':
            enabled_certificate_plugins => ['simple_certificate','dogtag'],
            host_href                   => 'http://localhost:9311'
          }
        }
      }
    EOS

    it 'should work with no errors' do
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if os[:family].casecmp('RedHat') == 0
      describe 'store a secret' do
        it 'should store a secret' do
          shell('barbican -N --os-project-id 12345 --endpoint http://localhost:9311 secret store --payload "my big bad secret"') do |r|
            expect(r.stdout).to match(/ACTIVE/)
          end
        end
      end

      describe 'generate a secret' do
        it 'should generate a secret' do
          shell('barbican -N --os-project-id 12345 --endpoint http://localhost:9311 secret order create key --name foo') do |r|
            expect(r.stdout).to match(/Order href/)
          end
        end
      end

      describe port(9311) do
        it { is_expected.to be_listening.with('tcp') }
      end
    end
  end
end
