ENV['RAILS_ENV'] ||= 'test'

require 'factory_bot_rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires any files in spec/utils
Dir[Rails.root.join('spec/utils/*.rb')].each { |file| require file }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryBot::Syntax::Methods
end

RSpec::Matchers.define_negated_matcher :not_change, :change

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end