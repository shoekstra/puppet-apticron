require 'spec_helper_acceptance'

describe 'apticron class', :if => "Debian".include?(fact('osfamily')) do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'apticron': mail_to => 'sysadmin@example.com' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('apticron') do
      it { is_expected.to be_installed }
    end
  end
end
