require 'rspec/core/kernel_extensions'
require 'rspec/core/object_extensions'
require 'rspec/core/load_path'
require 'rspec/core/deprecation'
require 'rspec/core/formatters'

require 'rspec/core/hooks'
require 'rspec/core/subject'
require 'rspec/core/let'
require 'rspec/core/metadata'
require 'rspec/core/pending'

require 'rspec/core/around_proxy'
require 'rspec/core/world'
require 'rspec/core/configuration'
require 'rspec/core/configuration_options'
require 'rspec/core/runner'
require 'rspec/core/example'
require 'rspec/core/shared_example_group'
require 'rspec/core/example_group'
require 'rspec/core/version'
require 'rspec/core/errors'

module RSpec
  module Core

    def self.install_directory
      @install_directory ||= File.expand_path(File.dirname(__FILE__))
    end

    def self.configuration
      RSpec.deprecate('RSpec::Core.configuration', 'RSpec.configuration', '2.0.0')
      RSpec.configuration
    end

    def self.configure
      RSpec.deprecate('RSpec::Core.configure', 'RSpec.configure', '2.0.0')
      yield RSpec.configuration if block_given?
    end

    def self.world
      RSpec.deprecate('RSpec::Core.world', 'RSpec.world', '2.0.0')
      RSpec.world
    end

  end

  RSpec::Runner = RSpec::Core::Runner
  RSpec::Runner::CommandLine = RSpec::Core::Runner

  def self.world
    @world ||= RSpec::Core::World.new
  end

  def self.configuration
    @configuration ||= RSpec::Core::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end

require 'rspec/core/backward_compatibility'

# TODO - make this configurable with default 'on'
require 'rspec/expectations'
