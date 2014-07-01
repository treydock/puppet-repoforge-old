require 'puppetlabs_spec_helper/module_spec_helper'

begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter '/spec/'
  end
rescue Exception => e
  warn "Coveralls disabled"
end

module LocalHelpers
  def default_facts
    {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :architecture           => 'x86_64',
    }
  end
end

RSpec.configure do |config|
  config.include ::LocalHelpers
end

UNSUPPORTED_OPERATINGSYSTEMS = [
  'Fedora',
  'Amazon',
]

at_exit { RSpec::Puppet::Coverage.report! }
