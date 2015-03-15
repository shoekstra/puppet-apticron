require 'spec_helper'

describe 'apticron' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'apticron class without any parameters' do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('apticron::params') }
          it { is_expected.to contain_class('apticron::install').that_comes_before('apticron::config') }
          it { is_expected.to contain_class('apticron::config').that_comes_before('apticron') }
          it { is_expected.to contain_class('apticron') }

          it { is_expected.to contain_package('apticron').with_ensure('present') }

          it { is_expected.to contain_file('/etc/cron.d/apticron').with_ensure('absent').that_comes_before('Cron[apticron]') }

          it { is_expected.to contain_cron('apticron').with(
            'ensure'   => 'present',
            'minute'   => 15,
            'hour'     => '*',
            'monthday' => '*',
            'month'    => '*',
            'weekday'  => '*',
            'user'     => 'root',
            'command'  => 'if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi',
          )}

          it { is_expected.to contain_file('/etc/apticron/apticron.conf').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644'
          )}
          it { is_expected.to contain_file("/etc/apticron/apticron.conf").with_content %r{^EMAIL="root@#{facts[:fqdn]}"$} }
        end

        context 'apticron class with custom parameters' do
          describe 'test ensure parameter' do
            [ 'latest', '1.1', 'absent'].each do |ensure_param|
              describe "when set to #{ensure_param}" do
              let(:params) {{
                :ensure => ensure_param
              }}

              if ensure_param == 'absent'
                it { is_expected.to contain_package('apticron').with_ensure('absent') }
                it { is_expected.to contain_cron('apticron').with_ensure('absent') }
                it { is_expected.to contain_file('/etc/apticron/apticron.conf').with_ensure('absent') }
              else
                it { is_expected.to contain_package('apticron').with_ensure(ensure_param) }
                it { is_expected.to contain_cron('apticron').with_ensure('present') }
                it { is_expected.to contain_file('/etc/apticron/apticron.conf').with_ensure('present') }
              end
              end
            end
          end

          describe 'test cron job' do
            let(:params) {{
              :cron_hour => '1',
              :cron_minute => 1,
              :cron_month => '1',
              :cron_monthday => '1',
              :cron_weekday => '1',
            }}

            it { is_expected.to contain_cron('apticron').with(
              'ensure'   => 'present',
              'minute'   => 1,
              'hour'     => 1,
              'monthday' => 1,
              'month'    => 1,
              'weekday'  => 1,
              'user'     => 'root',
              'command'  => 'if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi',
            )}
          end

          describe 'test apticron.conf template' do
            [
              {
                :attr  => 'custom_subject',
                :value => 'test',
                :match => [/^CUSTOM_SUBJECT="test"$/]
              },
              {
                :attr  => 'diff_only',
                :value => true,
                :match => [/^DIFF_ONLY="1"$/]
              },
              {
                :attr  => 'diff_only',
                :value => false,
                :match => [/^DIFF_ONLY="0"$/]
              },
              {
                :attr  => 'mail_from',
                :value => 'root@server.example.com',
                :match => [/^CUSTOM_FROM="root@server.example.com"$/]
              },
              {
                :attr  => 'notify_holds',
                :value => true,
                :match => [/^NOTIFY_HOLDS="1"$/]
              },
              {
                :attr  => 'notify_holds',
                :value => false,
                :match => [/^NOTIFY_HOLDS="0"$/]
              },
              {
                :attr  => 'notify_new',
                :value => true,
                :match => [/^NOTIFY_NEW="1"$/]
              },
              {
                :attr  => 'notify_new',
                :value => false,
                :match => [/^NOTIFY_NEW="0"$/]
              }
            ].each do |param|
              describe "when #{param[:attr]} parameter set to #{param[:value]}" do
                let(:params) {{ param[:attr].to_sym => param[:value] }}

                it { is_expected.to contain_file('/etc/apticron/apticron.conf').with_content(param[:match]) }
              end
            end
          end

          # context "apticron class with custom parameters" do
          #   let(:params) {{
          #     :ensure => present,
          #     :custom_subject => 'test',
          #     :diff_only => false,
          #     :mail_from => undef,
          #     :mail_to => "root@${::fqdn}",
          #     :notify_holds => true,
          #     :notify_new => false,
          #   }}


          #   it { is_expected.to compile.with_all_deps }

          #   it { is_expected.to contain_class('apticron::params') }
          #   it { is_expected.to contain_class('apticron::install').that_comes_before('apticron::config') }
          #   it { is_expected.to contain_class('apticron::config').that_comes_before('apticron') }
          #   it { is_expected.to contain_class('apticron') }

          #   it { is_expected.to contain_package('apticron').with_ensure('present') }

          #   it { is_expected.to contain_file('/etc/cron.d/apticron').with_ensure('absent').that_comes_before('Cron[apticron]') }


          #   it { is_expected.to contain_file('/etc/apticron/apticron.conf').with(
          #     'ensure' => 'present',
          #     'owner'  => 'root',
          #     'group'  => 'root',
          #     'mode'   => '0644'
          #   )}
          #   it { is_expected.to contain_file("/etc/apticron/apticron.conf").with_content %r{^EMAIL="root@#{facts[:fqdn]}"$} }
          # end

        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'apticron class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('apticron') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
