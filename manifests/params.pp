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
# Copyright 2013 Trey Dockendorf
#
class repoforge::params {
  $gpgkey_path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag'

  $repoforge_baseurl             = "http://apt.sw.be/redhat/el${::os_maj_version}/en/${::architecture}/rpmforge"
  $repoforge_mirrorlist          = "http://mirrorlist.repoforge.org/el${::os_maj_version}/mirrors-rpmforge"
  $repoforge_enabled             = '1'
  $repoforge_protect             = '0'
  $repoforge_gpgkey              = "file://${gpgkey_path}"
  $repoforge_gpgcheck            = '1'
  $repoforge_descr               = "RHEL ${::os_maj_version} - RPMforge.net - dag"
  $repoforge_extras_baseurl      = "http://apt.sw.be/redhat/el${::os_maj_version}/en/${::architecture}/extras"
  $repoforge_extras_mirrorlist   = "http://mirrorlist.repoforge.org/el${::os_maj_version}/mirrors-rpmforge-extras"
  $repoforge_extras_enabled      = '0'
  $repoforge_extras_protect      = '0'
  $repoforge_extras_gpgkey       = "file://${gpgkey_path}"
  $repoforge_extras_gpgcheck     = '1'
  $repoforge_extras_descr        = "RHEL ${::os_maj_version} - RPMforge.net - extras"
  $repoforge_testing_baseurl     = "http://apt.sw.be/redhat/el${::os_maj_version}/en/${::architecture}/testing"
  $repoforge_testing_mirrorlist  = "http://mirrorlist.repoforge.org/el${::os_maj_version}/mirrors-rpmforge-testing"
  $repoforge_testing_enabled     = '0'
  $repoforge_testing_protect     = '0'
  $repoforge_testing_gpgkey      = "file://${gpgkey_path}"
  $repoforge_testing_gpgcheck    = '1'
  $repoforge_testing_descr       = "RHEL ${::os_maj_version} - RPMforge.net - testing"

}
