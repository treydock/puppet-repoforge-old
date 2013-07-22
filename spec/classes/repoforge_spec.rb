require 'spec_helper'

shared_context :base do
  it do
    should contain_yumrepo('rpmforge').with({
      'baseurl'     => "http://apt.sw.be/redhat/el#{facts[:os_maj_version]}/en/#{facts[:architecture]}/rpmforge",
      'mirrorlist'  => "http://mirrorlist.repoforge.org/el#{facts[:os_maj_version]}/mirrors-rpmforge",
      'enabled'     => '1',
      'protect'     => '0',
      'gpgkey'      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      'gpgcheck'    => '1',
      'descr'       => "RHEL #{facts[:os_maj_version]} - RPMforge.net - dag",
    })
  end
end

shared_context :extras do
  it do
    should contain_yumrepo('rpmforge-extras').with({
      'baseurl'     => "http://apt.sw.be/redhat/el#{facts[:os_maj_version]}/en/#{facts[:architecture]}/extras",
      'mirrorlist'  => "http://mirrorlist.repoforge.org/el#{facts[:os_maj_version]}/mirrors-rpmforge-extras",
      'enabled'     => '0',
      'protect'     => '0',
      'gpgkey'      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      'gpgcheck'    => '1',
      'descr'       => "RHEL #{facts[:os_maj_version]} - RPMforge.net - extras",
    })
  end
end

shared_context :testing do
  it do
    should contain_yumrepo('rpmforge-testing').with({
      'baseurl'     => "http://apt.sw.be/redhat/el#{facts[:os_maj_version]}/en/#{facts[:architecture]}/testing",
      'mirrorlist'  => "http://mirrorlist.repoforge.org/el#{facts[:os_maj_version]}/mirrors-rpmforge-testing",
      'enabled'     => '0',
      'protect'     => '0',
      'gpgkey'      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      'gpgcheck'    => '1',
      'descr'       => "RHEL #{facts[:os_maj_version]} - RPMforge.net - testing",
    })
  end
end

shared_context :gpgkey do
  it do
    should contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag").with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
      'source' => "puppet:///modules/repoforge/RPM-GPG-KEY-rpmforge-dag",
    })
  end

  it do
    should contain_gpg_key("RPM-GPG-KEY-rpmforge-dag").with({
      'path'    => "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
      'before'  => ['Yumrepo[rpmforge]','Yumrepo[rpmforge-extras]','Yumrepo[rpmforge-testing]'],
    })
  end
end

describe 'repoforge' do
  let(:facts) { default_facts }

  it { should create_class('repoforge') }
  it { should contain_class('repoforge::params') }

  context "operatingsystem => CentOS" do
    context 'os_maj_version => 6' do
      include_context :base
      include_context :extras
      include_context :testing
      include_context :gpgkey

      let :facts do
        default_facts.merge({
          :operatingsystemrelease => '6.4',
          :os_maj_version         => '6',
        })
      end

      context 'repoforge_baseurl => http://example.com/repoforge/6/x86_64' do
        let(:params) {{ :repoforge_baseurl => "http://example.com/repoforge/6/x86_64" }}
        it { should contain_yumrepo('rpmforge').with('baseurl'  => 'http://example.com/repoforge/6/x86_64') }
      end
      
      context 'repoforge_mirrorlist => absent' do
        let(:params) {{ :repoforge_mirrorlist => 'absent' }}
        it { should contain_yumrepo('rpmforge').with('mirrorlist'  => 'absent') }
      end
    end

    context "operatingsystem => CentOS" do
      context 'os_maj_version => 5' do
        include_context :base
        include_context :extras
        include_context :testing
        include_context :gpgkey

        let :facts do
          default_facts.merge({
            :operatingsystemrelease => '5.9',
            :os_maj_version         => '5',
          })
        end

        context 'repoforge_baseurl => http://example.com/repoforge/5/x86_64' do
          let(:params) {{ :repoforge_baseurl => "http://example.com/repoforge/5/x86_64" }}
          it { should contain_yumrepo('rpmforge').with('baseurl'  => 'http://example.com/repoforge/5/x86_64') }
        end
      
        context 'repoforge_mirrorlist => absent' do
          let(:params) {{ :repoforge_mirrorlist => 'absent' }}
          it { should contain_yumrepo('rpmforge').with('mirrorlist'  => 'absent') }
        end
      end
    end

    UNSUPPORTED_OPERATINGSYSTEMS.each do |operatingsystem|
      context "operatingsystem => #{operatingsystem}" do
        let :facts do
          default_facts.merge({
            :operatingsystem        => operatingsystem,
            :operatingsystemrelease => '0',
            :os_maj_version         => '0',
          })
        end
      
        it { should_not contain_yumrepo('rpmforge') }
        it { should_not contain_yumrepo('rpmforge-extras') }
        it { should_not contain_yumrepo('rpmforge-testing') }
      
        it { should contain_notify("Your operating system #{facts[:operatingsystem]} will not have the rpmforge repository applied") }
      end
    end
  end
end
