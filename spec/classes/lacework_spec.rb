# frozen_string_literal: true

require 'spec_helper'

describe 'lacework' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:conf_path) { '/var/lib/lacework/config/config.json' }
      let(:params) do
        { 'access_token' => 'no' }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('lacework::files') }

      describe 'lacework::files' do
        it { is_expected.to contain_file('/var/lib/lacework').with_owner('root') }
        it { is_expected.to contain_file('/var/lib/lacework').with_group('root') }
        it { is_expected.to contain_file('/var/lib/lacework').with_ensure('directory') }
        it { is_expected.to contain_file('/var/lib/lacework').with_mode('0755') }
        it { is_expected.to contain_file('/var/lib/lacework/config').with_mode('0755') }
        it { is_expected.to contain_file('/var/lib/lacework/config').with_ensure('directory') }
        it { is_expected.to contain_file('/var/lib/lacework/config/config.json').with_mode('0660') }
        it { is_expected.to contain_file(conf_path).with('content' => %r{\"AccessToken\"\: \"no\"}) }
      end

      describe 'lacework::package' do
        if os_facts[:osfamily] == 'Debian'
          it { is_expected.to contain_class('apt') }
          it {
            is_expected.to contain_apt__key('lacework').with(
              id: '360D55D76727556814078E25FF3E1D4DEE0CC692',
            )
          }

          case os_facts[:operatingsystemmajrelease]
          when '8'
            it {
              is_expected.to contain_apt__source('lacework').with(
            'location': 'https://packages.lacework.net/DEB/debian/8',
            'release': 'jessie',
            'repos': 'main',
          )
            }
          when '9'
            it {
              is_expected.to contain_apt__source('lacework').with(
            'location': 'https://packages.lacework.net/DEB/debian/9',
            'release': 'stretch',
            'repos': 'main',
          )
            }
          when '10'
            it {
              is_expected.to contain_apt__source('lacework').with(
            'location': 'https://packages.lacework.net/DEB/debian/10',
            'release': 'buster',
            'repos': 'main',
          )
            }
          end

        elsif os_facts[:osfamily] == 'RedHat'
          it {
            is_expected.to contain_yumrepo('lacework').with(
            'baseurl': 'https://packages.lacework.net/RPMS/x86_64/',
          )
          }
        end

        it {
          is_expected.to contain_package('lacework').with(
          ensure: 'present',
        )
        }
      end

      describe 'lacework::service' do
        it {
          is_expected.to contain_service('datacollector').with(
          ensure: 'running',
        )
        }
      end
    end
  end
end
