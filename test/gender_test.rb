require_relative 'test_helper'

class GenderTest < Minitest::Test
  def test_from_s
    identifier = 'GENDER:M'
    
    Milday::Gender.from_s(identifier).tap do |entry|
      assert_equal(entry.identifier, 'M')
    end
  end
  
  def test_initialize_with_valid_sex_component_key
    assert_runs_without_errors do
      Milday::Gender.new('male').tap do |entry|
        assert_equal(entry.identifier, 'M')
        assert_equal(entry.sex, :male)
      end
    end
  end
  
  def test_initialize_with_invalid_identifier
    assert_raises(ArgumentError) do
      Milday::Gender.new('invalid-identifier')
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
