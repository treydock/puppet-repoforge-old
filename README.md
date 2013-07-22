# puppet-repoforge

# Description
This module basically just mimics the rpmforge-release rpm. The same repos are
enabled/disabled and the GPG key is imported.  In the end you will end up with
the RepoForge repos configured.

The following repos will be setup and enabled by default:

  * rpmforge

Other repositories that will setup but disabled (as per the rpmforge-release setup)

  * rpmforge-extras
  * rpmforge-testing

## Usage

    class { 'repoforge': }

# Testing

Tested using the following operating systems

* CentOS 6.4
* CentOS 5.9

## Unit tests

Install the necessary gems

    bundle install

Run the RSpec and puppet-lint tests

    bundle exec rake ci
    
## System tests

If you have Vagrant >=1.1.0 you can also run system tests:

    bundle exec rake spec:system
    RSPEC_SET=centos-59-x64 bundle exec rake spec:system

Available RSPEC_SET options are in .nodeset.yml


# Futher Information

* [RepoForge](http://repoforge.org/)
