require_relative 'test_helper'

class PhoneTest < Minitest::Test
  def test_to_s_with_single_type
    Milday::Phone.new('01000000000', type: :voice).tap do |phone|
      assert_equal(phone.to_s.start_with?('TEL;TYPE=voice:'), true)
    end
  end
  
  def test_to_s_with_multiple_types
    Milday::Phone.new('01000000000', type: %i[voice work]).tap do |phone|
      assert_equal(phone.to_s, 'TEL;TYPE="voice,work":01000000000')
    end
  end
  
  def test_with_invalid_position
    error = assert_raises(ArgumentError) do
      Milday::Phone.new('01000000000', position: -1)
    end
    
    assert_equal(error.message, 'Invalid Position')
  end
  
  def test_to_s_with_position
    Milday::Phone.new('01000000000', type: :voice, position: 1).tap do |phone|
      assert_equal(phone.to_s, 'TEL;PERF=1;TYPE=voice:01000000000')
    end
  end
end
