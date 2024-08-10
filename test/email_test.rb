require 'minitest/autorun'
require 'milday/email'

class EmailTest < Minitest::Test
  def test_to_s_with_single_type
    Milday::Email.new(address: 'ahmed@hellotext.com', type: :work).tap do |email|
      assert_equal(email.to_s.start_with?('EMAIL;TYPE=work:'), true)
    end
  end
  
  def test_to_s_with_preferred
    Milday::Email.new(address: 'ahmed@hellotext.com', type: :work, preferred: true).tap do |email|
      assert_equal(
        email.to_s.include?(';PERF=1;'),
        true
      )
    end
  end
end
