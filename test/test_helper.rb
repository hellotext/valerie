require 'minitest/autorun'
require_relative '../lib/milday'

module Minitest::Assertions
  def assert_runs_without_errors(*)
    yield
  end
end
