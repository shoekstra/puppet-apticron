require 'spec_helper'

describe 'apticron', :type => :class do
  context "osfamily => 'Debian'" do
    let(:facts) {{ :osfamily => 'Debian' }}

    describe "with mail_to => 'apticron@example.com'" do
      let(:params) {{ :mail_to => 'apticron@example.com' }}

      it { should compile.with_all_deps }

      it { should contain_class('apticron::params') }
      it { should contain_class('apticron::install').that_comes_before('apticron::config') }
      it { should contain_class('apticron::config').that_notifies('apticron::cron') }
      it { should contain_class('apticron::cron').that_notifies('apticron') }
      it { should contain_class('apticron') }
      it { should contain_file('/etc/apticron/apticron.conf').with(
        'ensure' => 'present',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644'
      )}
      it { should contain_file("/etc/apticron/apticron.conf").with_content %r{^EMAIL="apticron@example.com"\n} }
      it { should contain_package('apticron').with_ensure('present') }

      describe "custom_subject => 'apticron custom subject'" do
        let(:params) {{ :mail_to => 'apticron@example.com', :custom_subject => "apticron custom subject" }}

        it do
          should contain_file('/etc/apticron/apticron.conf').with_content(/^CUSTOM_SUBJECT="apticron custom subject"$/)
        end
      end

      describe "mail_from => 'root@server.example.com'" do
        let(:params) {{ :mail_to => 'apticron@example.com', :mail_from => "root@server.example.com" }}

        it do
          should contain_file('/etc/apticron/apticron.conf').with_content(/^CUSTOM_FROM="root@server.example.com"$/)
        end
      end

      describe "diff_only" do
        context "=> true" do
          let(:params) {{ :mail_to => 'apticron@example.com', :diff_only => true }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^DIFF_ONLY="1"$/)
          end
        end

        context "=> false" do
          let(:params) {{ :mail_to => 'apticron@example.com', :diff_only => false }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^DIFF_ONLY="0"$/)
          end
        end
      end

      describe "notify_holds" do
        context "=> true" do
          let(:params) {{ :mail_to => 'apticron@example.com', :notify_holds => true }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^NOTIFY_HOLDS="1"$/)
          end
        end

        context "=> false" do
          let(:params) {{ :mail_to => 'apticron@example.com', :notify_holds => false }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^NOTIFY_HOLDS="0"$/)
          end
        end
      end

      describe "notify_new" do
        context "=> true" do
          let(:params) {{ :mail_to => 'apticron@example.com', :notify_new => true }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^NOTIFY_NEW="1"$/)
          end
        end

        context "=> false" do
          let(:params) {{ :mail_to => 'apticron@example.com', :notify_new => false }}

          it do
            should contain_file('/etc/apticron/apticron.conf').with_content(/^NOTIFY_NEW="0"$/)
          end
        end
      end
    end
  end

  context "osfamily => 'Solaris' (unsupported operating system)" do
    let(:facts) {{ :osfamily => 'Solaris' }}

    it { expect { should contain_package('apticron') }.to raise_error(Puppet::Error, /apticron module not supported on Solaris/) }
  end
end
