ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'vcr'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.filter_run focus: true
  config.mock_with  :rspec

  config.run_all_when_everything_filtered                = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.use_transactional_fixtures                      = false

  config.extend  VCR::RSpec::Macros

  config.before :suite do
    Plan.delete_all
    Plan.create name: 'Dickbutts',      price: 10.00
    Plan.create name: 'More Dickbutts', price: 15.00

    DatabaseCleaner.strategy = :truncation, { except: %w[ plans ]}
  end

  config.before :each do
    DatabaseCleaner.clean
  end

end

VCR.config do |config|
  config.cassette_library_dir     = 'spec/data'
  config.default_cassette_options = { :record => :none }
  config.ignore_localhost         = true

  config.stub_with :webmock
end
