require 'spec_helper_system'

describe 'standage usage tests:' do
  context 'test disabling mirrorlist' do
    facts = node.facts
    os_maj_version = facts['operatingsystemrelease'].split('.')[0]
    pp = <<-EOS
      class { 'repoforge':
        repoforge_mirrorlist => 'absent',
      }
    EOS

    context puppet_apply pp do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end

    # Only test for presence if not Fedora
    if facts['operatingsystem'] !~ /Fedora/
      # Test the yum config to ensure mirrorlist was emptied
      context shell '/usr/bin/yum-config-manager rpmforge | egrep "^mirrorlist ="' do
        its(:stdout) { should =~ /mirrorlist =\s+/ }
      end
    end
  end

  context 'test rpmforge-extras is enabled' do
    facts = node.facts
    pp = <<-EOS
      class { 'repoforge':
        repoforge_extras_enabled    => '1',
      }
    EOS

    context puppet_apply pp do
      its(:stderr) { should be_empty }
      its(:exit_code) { should_not == 1 }
      its(:refresh) { should be_nil }
      its(:stderr) { should be_empty }
      its(:exit_code) { should be_zero }
    end

    # Only test for presence if not Fedora
    if facts['operatingsystem'] !~ /Fedora/
      # Test the yum config to ensure rpmforge-extras was enabled
      context shell '/usr/bin/yum-config-manager rpmforge-extras | grep -q "enabled = True"' do
        its(:exit_code) { should be_zero }
      end
    end
  end
end
