require 'test_helper'

class GenderTest < Minitest::Test
  def test_from_s
    identifier = 'GENDER:M'
    
    Milday::Gender.from_s(identifier).tap do |entry|
      assert_equal(entry.identifier, 'M')
    end
  end
  
  def test_to_s
    assert_equal(Milday::Gender.new('M').to_s, 'GENDER:M')
  end
  
  def test_to_h
    Milday::Gender.new('M').to_h.tap do |hash|
      assert_equal(hash[:identifier], 'M')
    end
  end
end
