require_relative 'test_helper'

class EmailTest < Minitest::Test
  def test_to_s_with_single_type
    Valerie::Email.new(address: 'ahmed@hellotext.com', type: :work).tap do |email|
      assert_equal(email.to_s.start_with?('EMAIL;TYPE=work:'), true)
    end
  end
  
  def test_with_invalid_position
    error = assert_raises(ArgumentError) do
      Valerie::Email.new(address: 'ahmed@hellotext.com', position: -1)
    end
    
    assert_equal(error.message, 'Invalid Position')
  end
  
  def test_to_s_with_preferred
    Valerie::Email.new(address: 'ahmed@hellotext.com', type: :work, position: 1).tap do |email|
      assert_equal(
        email.to_s.include?(';PERF=1;'),
        true
      )
    end
  end
end
