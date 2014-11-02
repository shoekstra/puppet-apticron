require 'spec_helper'

describe 'apticron', :type => :class do
  let :default_params do
    { :mail_to => 'apticron@example.com' }
  end

  context "supported OS families" do
    describe "Debian" do
      let(:facts) {{ :osfamily => 'Debian' }}

      describe "when $mail_to is 'apticron@example.com'" do
        let :params do default_params.merge({}) end

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
      end

      [
        {
          :attr  => 'mail_from',
          :value => 'root@server.example.com',
          :match => [/^CUSTOM_FROM="root@server.example.com"$/]
        },
        {
          :attr  => 'custom_subject',
          :value => 'apticron custom subject',
          :match => [/^CUSTOM_SUBJECT="apticron custom subject"$/]
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
        describe "when \$#{param[:attr]} is #{param[:value]}" do
          let :params do default_params.merge({ param[:attr].to_sym => param[:value] }) end

          it "should set #{param[:attr]} to \'#{param[:value]}\'" do
            should contain_file('/etc/apticron/apticron.conf').with_content(param[:match])
          end
        end
      end
    end
  end

  context "unsupported OS family" do
    describe "Solaris" do
      let(:facts) {{ :osfamily => 'Solaris' }}

      it { expect { should contain_package('apticron') }.to raise_error(Puppet::Error, /apticron module not supported on Solaris/) }
    end
  end
end
