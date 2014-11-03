require 'spec_helper_acceptance'

describe 'apticron class', :if => "Debian".include?(fact('osfamily')) do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'apticron': mail_to => 'sysadmin@example.com' }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package('apticron') do
      it { should be_installed }
    end
  end
end
