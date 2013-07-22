require 'puppetlabs_spec_helper/module_spec_helper'

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