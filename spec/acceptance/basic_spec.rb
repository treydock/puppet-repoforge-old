require 'spec_helper_acceptance'

describe 'repoforge class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp = <<-EOS
        class { 'repoforge': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe yumrepo('rpmforge') do
      it { should exist }
      it { should be_enabled }
    end
  end

  context 'with mirrorlist => "absent"' do
    it 'should run successfully' do
      pp = <<-EOS
        class { 'repoforge': mirrorlist => "absent" }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'with extras_enabled => "1"' do
    it 'should run successfully' do
      pp = <<-EOS
        class { 'repoforge': extras_enabled => "1" }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
