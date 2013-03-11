require 'spork'
require 'simplecov'
require 'coveralls'
Coveralls.wear!
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  unless ENV['DRB']
    SimpleCov.start 'rails'
    require File.expand_path("../../config/environment", __FILE__)
  end

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require 'capybara/rspec'

  # files to preload based on results of Kernel override code below
  # ie they took more than 100 ms to load
  require "sprockets"
  require "sprockets/eco_template"
  require "sprockets/base"
  require "active_record/connection_adapters/postgresql_adapter"
  require "tzinfo"
  require "tilt"
  require "journey"
  require "journey/router"
  require "haml/template"

  RSpec.configure do |config|
    config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.include FactoryGirl::Syntax::Methods

    config.before :suite do
      # PerfTools::CpuProfiler.start("/tmp/rspec_profile")
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    # Request specs cannot use a transaction because Capybara runs in a
    # separate thread with a different database connection.
    config.before type: :request do
      DatabaseCleaner.strategy = :truncation
    end

    # Reset so other non-request specs don't have to deal with slow truncation.
    config.after type: :request  do
      DatabaseCleaner.strategy = :transaction
    end

    RESERVED_IVARS = %w(@loaded_fixtures)
    last_gc_run = Time.now

    config.before(:each) do
      GC.disable
    end

    config.before do
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end

    # Release instance variables and trigger garbage collection
    # manually every second to make tests faster
    # http://blog.carbonfive.com/2011/02/02/crank-your-specs/
    config.after(:each) do
      (instance_variables - RESERVED_IVARS).each do |ivar|
        instance_variable_set(ivar, nil)
      end
      if Time.now - last_gc_run > 1.0
        GC.enable
        GC.start
        last_gc_run = Time.now
      end
    end

    config.after :suite do
      # PerfTools::CpuProfiler.stop

      # REPL to query ObjectSpace
      # http://blog.carbonfive.com/2011/02/02/crank-your-specs/
      # while true
      #   '> '.display
      #   begin
      #     puts eval($stdin.gets)
      #   rescue Exception => e
      #     puts e.message
      #   end
      # end
    end
  end

  # Find files to put into preload
  # http://www.opinionatedprogrammer.com/2011/02/profiling-spork-for-faster-start-up-time/
  # module Kernel
  #   def require_with_trace(*args)
  #     start = Time.now.to_f
  #     @indent ||= 0
  #     @indent += 2
  #     require_without_trace(*args)
  #     @indent -= 2
  #     Kernel::puts "#{' '*@indent}#{((Time.now.to_f - start)*1000).to_i} #{args[0]}"
  #   end
  #   alias_method_chain :require, :trace
  # end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  if ENV['DRB']
    SimpleCov.start 'rails'
    SampleApp::Application.initialize!
    class SampleApp::Application
      def initialize!; end
    end
  end

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  FactoryGirl.reload
  I18n.backend.reload!
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
