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
# Copyright 2014 Trey Dockendorf
#
class repoforge (
  $gpgkey_path          = $repoforge::params::gpgkey_path,
  $baseurl              = $repoforge::params::baseurl,
  $mirrorlist           = $repoforge::params::mirrorlist,
  $enabled              = $repoforge::params::enabled,
  $protect              = $repoforge::params::protect,
  $gpgkey               = $repoforge::params::gpgkey,
  $gpgcheck             = $repoforge::params::gpgcheck,
  $descr                = $repoforge::params::descr,
  $includepkgs          = 'absent',
  $exclude              = 'absent',
  $extras_baseurl       = $repoforge::params::extras_baseurl,
  $extras_mirrorlist    = $repoforge::params::extras_mirrorlist,
  $extras_enabled       = $repoforge::params::extras_enabled,
  $extras_protect       = $repoforge::params::extras_protect,
  $extras_gpgkey        = $repoforge::params::extras_gpgkey,
  $extras_gpgcheck      = $repoforge::params::extras_gpgcheck,
  $extras_descr         = $repoforge::params::extras_descr,
  $extras_includepkgs   = 'absent',
  $extras_exclude       = 'absent',
  $testing_baseurl      = $repoforge::params::testing_baseurl,
  $testing_mirrorlist   = $repoforge::params::testing_mirrorlist,
  $testing_enabled      = $repoforge::params::testing_enabled,
  $testing_protect      = $repoforge::params::testing_protect,
  $testing_gpgkey       = $repoforge::params::testing_gpgkey,
  $testing_gpgcheck     = $repoforge::params::testing_gpgcheck,
  $testing_descr        = $repoforge::params::testing_descr,
  $testing_includepkgs  = 'absent',
  $testing_exclude      = 'absent',
) inherits repoforge::params {

  if $::osfamily == 'RedHat' and $::operatingsystem !~ /Fedora|Amazon/ {
    yumrepo { 'rpmforge':
      baseurl     => $baseurl,
      mirrorlist  => $mirrorlist,
      enabled     => $enabled,
      protect     => $protect,
      gpgcheck    => $gpgcheck,
      gpgkey      => $gpgkey,
      descr       => $descr,
      includepkgs => $includepkgs,
      exclude     => $exclude,
    }

    yumrepo { 'rpmforge-extras':
      baseurl     => $extras_baseurl,
      mirrorlist  => $extras_mirrorlist,
      enabled     => $extras_enabled,
      protect     => $extras_protect,
      gpgcheck    => $extras_gpgcheck,
      gpgkey      => $extras_gpgkey,
      descr       => $extras_descr,
      includepkgs => $extras_includepkgs,
      exclude     => $extras_exclude,
    }

    yumrepo { 'rpmforge-testing':
      baseurl     => $testing_baseurl,
      mirrorlist  => $testing_mirrorlist,
      enabled     => $testing_enabled,
      protect     => $testing_protect,
      gpgcheck    => $testing_gpgcheck,
      gpgkey      => $testing_gpgkey,
      descr       => $testing_descr,
      includepkgs => $testing_includepkgs,
      exclude     => $testing_exclude,
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
