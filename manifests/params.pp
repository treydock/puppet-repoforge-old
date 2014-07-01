# Class: repoforge::params
#
#   The repoforge configuration settings.
#
# === Variables
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2014s Trey Dockendorf
#
class repoforge::params {
  $gpgkey_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag'

  $baseurl_host        = 'http://apt.sw.be'
  $baseurl             = "${baseurl_host}/redhat/el${::operatingsystemmajrelease}/en/${::architecture}/rpmforge"
  $mirrorlist          = "http://mirrorlist.repoforge.org/el${::operatingsystemmajrelease}/mirrors-rpmforge"
  $enabled             = '1'
  $protect             = '0'
  $gpgkey              = "file://${gpgkey_path}"
  $gpgcheck            = '1'
  $descr               = "RHEL ${::operatingsystemmajrelease} - RPMforge.net - dag"
  $extras_baseurl      = "${baseurl_host}/redhat/el${::operatingsystemmajrelease}/en/${::architecture}/extras"
  $extras_mirrorlist   = "http://mirrorlist.repoforge.org/el${::operatingsystemmajrelease}/mirrors-rpmforge-extras"
  $extras_enabled      = '0'
  $extras_protect      = '0'
  $extras_gpgkey       = "file://${gpgkey_path}"
  $extras_gpgcheck     = '1'
  $extras_descr        = "RHEL ${::operatingsystemmajrelease} - RPMforge.net - extras"
  $testing_baseurl     = "${baseurl_host}/redhat/el${::operatingsystemmajrelease}/en/${::architecture}/testing"
  $testing_mirrorlist  = "http://mirrorlist.repoforge.org/el${::operatingsystemmajrelease}/mirrors-rpmforge-testing"
  $testing_enabled     = '0'
  $testing_protect     = '0'
  $testing_gpgkey      = "file://${gpgkey_path}"
  $testing_gpgcheck    = '1'
  $testing_descr       = "RHEL ${::operatingsystemmajrelease} - RPMforge.net - testing"

}
