# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'faker'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include SessionsHelper
    include FactoryBot::Syntax::Methods

    def log_in(user)
      post sessions_url, params: { session: { email: user.email, password: user.password } }
    end

    def assert_attributes(model_name, attributes_hash)
      attributes_hash.each do |key, value|
        assert_equal value, model_name.send(key)
      end
    end
  end
end
