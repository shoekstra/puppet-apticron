require 'spec_helper'

describe 'apticron::cron', :type => :class do
  describe 'with package defaults' do
    let(:params) {{ 
      :minute   => 15,
      :hour     => '*',
      :monthday => '*',
      :month    => '*',
      :weekday  => '*',
    }}

    it { should compile.with_all_deps }

    it { should contain_file('/etc/cron.d/apticron').with_ensure('absent').that_comes_before('Cron[apticron]') }
    it { should contain_cron('apticron').with(
      'ensure'   => 'present',
      'minute'   => 15,
      'hour'     => '*',
      'monthday' => '*',
      'month'    => '*',
      'weekday'  => '*',
      'user'     => 'root',
      'command'  => 'if test -x /usr/sbin/apticron; then /usr/sbin/apticron --cron; else true; fi',
    )}
  end
end
