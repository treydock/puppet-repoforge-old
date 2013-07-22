# == Class: repoforge
#
# Configure the RepoForge repositories and import GPG keys
#
# === Parameters
#
# === Examples
#
#  class { 'repoforge': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class repoforge (
  $gpgkey_path                   = $repoforge::params::gpgkey_path,
  $repoforge_baseurl             = $repoforge::params::repoforge_baseurl,
  $repoforge_mirrorlist          = $repoforge::params::repoforge_mirrorlist,
  $repoforge_enabled             = $repoforge::params::repoforge_enabled,
  $repoforge_protect             = $repoforge::params::repoforge_protect,
  $repoforge_gpgkey              = $repoforge::params::repoforge_gpgkey,
  $repoforge_gpgcheck            = $repoforge::params::repoforge_gpgcheck,
  $repoforge_descr               = $repoforge::params::repoforge_descr,
  $repoforge_extras_baseurl      = $repoforge::params::repoforge_extras_baseurl,
  $repoforge_extras_mirrorlist   = $repoforge::params::repoforge_extras_mirrorlist,
  $repoforge_extras_enabled      = $repoforge::params::repoforge_extras_enabled,
  $repoforge_extras_protect      = $repoforge::params::repoforge_extras_protect,
  $repoforge_extras_gpgkey       = $repoforge::params::repoforge_extras_gpgkey,
  $repoforge_extras_gpgcheck     = $repoforge::params::repoforge_extras_gpgcheck,
  $repoforge_extras_descr        = $repoforge::params::repoforge_extras_descr,
  $repoforge_testing_baseurl     = $repoforge::params::repoforge_testing_baseurl,
  $repoforge_testing_mirrorlist  = $repoforge::params::repoforge_testing_mirrorlist,
  $repoforge_testing_enabled     = $repoforge::params::repoforge_testing_enabled,
  $repoforge_testing_protect     = $repoforge::params::repoforge_testing_protect,
  $repoforge_testing_gpgkey      = $repoforge::params::repoforge_testing_gpgkey,
  $repoforge_testing_gpgcheck    = $repoforge::params::repoforge_testing_gpgcheck,
  $repoforge_testing_descr       = $repoforge::params::repoforge_testing_descr
) inherits repoforge::params {

  if $::osfamily == 'RedHat' and $::operatingsystem !~ /Fedora|Amazon/ {
    yumrepo { 'rpmforge':
      baseurl     => $repoforge_baseurl,
      mirrorlist  => $repoforge_mirrorlist,
      enabled     => $repoforge_enabled,
      protect     => $repoforge_protect,
      gpgcheck    => $repoforge_gpgcheck,
      gpgkey      => $repoforge_gpgkey,
      descr       => $repoforge_descr,
    }

    yumrepo { 'rpmforge-extras':
      baseurl     => $repoforge_extras_baseurl,
      mirrorlist  => $repoforge_extras_mirrorlist,
      enabled     => $repoforge_extras_enabled,
      protect     => $repoforge_extras_protect,
      gpgcheck    => $repoforge_extras_gpgcheck,
      gpgkey      => $repoforge_extras_gpgkey,
      descr       => $repoforge_extras_descr,
    }

    yumrepo { 'rpmforge-testing':
      baseurl     => $repoforge_testing_baseurl,
      mirrorlist  => $repoforge_testing_mirrorlist,
      enabled     => $repoforge_testing_enabled,
      protect     => $repoforge_testing_protect,
      gpgcheck    => $repoforge_testing_gpgcheck,
      gpgkey      => $repoforge_testing_gpgkey,
      descr       => $repoforge_testing_descr,
    }

    file { $gpgkey_path:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/repoforge/RPM-GPG-KEY-rpmforge-dag',
    }

    gpg_key{ 'RPM-GPG-KEY-rpmforge-dag':
      path    => $gpgkey_path,
      before  => Yumrepo['rpmforge','rpmforge-extras','rpmforge-testing'],
    }
  } else {
    notify { "Your operating system ${::operatingsystem} will not have the rpmforge repository applied": }
  }

}
