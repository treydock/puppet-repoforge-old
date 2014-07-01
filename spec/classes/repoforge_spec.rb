require 'spec_helper'

shared_context :base do
  it do
    should contain_yumrepo('rpmforge').with({
      :name         => 'rpmforge',
      :baseurl      => "http://apt.sw.be/redhat/el#{facts[:operatingsystemmajrelease]}/en/#{facts[:architecture]}/rpmforge",
      :mirrorlist   => "http://mirrorlist.repoforge.org/el#{facts[:operatingsystemmajrelease]}/mirrors-rpmforge",
      :enabled      => '1',
      :protect      => '0',
      :gpgkey       => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      :gpgcheck     => '1',
      :descr        => "RHEL #{facts[:operatingsystemmajrelease]} - RPMforge.net - dag",
      :includepkgs  => 'absent',
      :exclude      => 'absent',
    })
  end
end

shared_context :extras do
  it do
    should contain_yumrepo('rpmforge-extras').with({
      :baseurl      => "http://apt.sw.be/redhat/el#{facts[:operatingsystemmajrelease]}/en/#{facts[:architecture]}/extras",
      :mirrorlist   => "http://mirrorlist.repoforge.org/el#{facts[:operatingsystemmajrelease]}/mirrors-rpmforge-extras",
      :enabled      => '0',
      :protect      => '0',
      :gpgkey       => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      :gpgcheck     => '1',
      :descr        => "RHEL #{facts[:operatingsystemmajrelease]} - RPMforge.net - extras",
      :includepkgs  => 'absent',
      :exclude      => 'absent',
    })
  end
end

shared_context :testing do
  it do
    should contain_yumrepo('rpmforge-testing').with({
      :baseurl      => "http://apt.sw.be/redhat/el#{facts[:operatingsystemmajrelease]}/en/#{facts[:architecture]}/testing",
      :mirrorlist   => "http://mirrorlist.repoforge.org/el#{facts[:operatingsystemmajrelease]}/mirrors-rpmforge-testing",
      :enabled      => '0',
      :protect      => '0',
      :gpgkey       => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
      :gpgcheck     => '1',
      :descr        => "RHEL #{facts[:operatingsystemmajrelease]} - RPMforge.net - testing",
      :includepkgs  => 'absent',
      :exclude      => 'absent',
    })
  end
end

shared_context :gpgkey do
  it do
    should contain_file("/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag").with({
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
      :source => "puppet:///modules/repoforge/RPM-GPG-KEY-rpmforge-dag",
    })
  end

  it do
    should contain_gpg_key("RPM-GPG-KEY-rpmforge-dag").with({
      :path    => "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
      :before  => ['Yumrepo[rpmforge]','Yumrepo[rpmforge-extras]','Yumrepo[rpmforge-testing]'],
    })
  end
end

describe 'repoforge' do
  let(:facts) { default_facts }

  it { should create_class('repoforge') }
  it { should contain_class('repoforge::params') }

  context "operatingsystem => CentOS" do
    context 'operatingsystemmajrelease => 6' do
      include_context :base
      include_context :extras
      include_context :testing
      include_context :gpgkey

      let :facts do
        default_facts.merge({
          :operatingsystemrelease     => '6.4',
          :operatingsystemmajrelease  => '6',
        })
      end

      context 'baseurl => http://example.com/repoforge/6/x86_64' do
        let(:params) {{ :baseurl => "http://example.com/repoforge/6/x86_64" }}
        it { should contain_yumrepo('rpmforge').with('baseurl'  => 'http://example.com/repoforge/6/x86_64') }
      end
      
      context 'mirrorlist => absent' do
        let(:params) {{ :mirrorlist => 'absent' }}
        it { should contain_yumrepo('rpmforge').with('mirrorlist'  => 'absent') }
      end

      context 'includepkgs => "foo*"' do
        let(:params) {{ :includepkgs => "foo*" }}
        it { should contain_yumrepo('rpmforge').with_includepkgs('foo*') }
      end

      context 'exclude => "bar*"' do
        let(:params) {{ :exclude => "bar*" }}
        it { should contain_yumrepo('rpmforge').with_exclude('bar*') }
      end
    end

    context "operatingsystem => CentOS" do
      context 'operatingsystemmajrelease => 5' do
        include_context :base
        include_context :extras
        include_context :testing
        include_context :gpgkey

        let :facts do
          default_facts.merge({
            :operatingsystemrelease     => '5.9',
            :operatingsystemmajrelease  => '5',
          })
        end

        context 'baseurl => http://example.com/repoforge/5/x86_64' do
          let(:params) {{ :baseurl => "http://example.com/repoforge/5/x86_64" }}
          it { should contain_yumrepo('rpmforge').with('baseurl'  => 'http://example.com/repoforge/5/x86_64') }
        end
      
        context 'mirrorlist => absent' do
          let(:params) {{ :mirrorlist => 'absent' }}
          it { should contain_yumrepo('rpmforge').with('mirrorlist'  => 'absent') }
        end
      end
    end

    UNSUPPORTED_OPERATINGSYSTEMS.each do |operatingsystem|
      context "operatingsystem => #{operatingsystem}" do
        let :facts do
          default_facts.merge({
            :operatingsystem        => operatingsystem,
            :operatingsystemrelease     => '0',
            :operatingsystemmajrelease  => '0',
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
