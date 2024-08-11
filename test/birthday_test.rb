require 'test_helper'

class BirthdayTest < Minitest::Test
  def test_from_s
    Milday::Birthday.from_s('BDAY:1999-11-04').to_date.tap do |date|
      assert_equal(date.year, 1999)
      assert_equal(date.month, 11)
      assert_equal(date.day, 4)
    end
  end
  
  def test_to_s
    assert_equal(
      Milday::Birthday.from_s('BDAY:1999-11-04').to_s,
      'BDAY:1999-11-04'
    )
  end
  
  def test_to_h
    Milday::Birthday.from_s('BDAY:1999-11-04').to_h.tap do |hash|
      assert_equal(hash[:year], 1999)
      assert_equal(hash[:month], 11)
      assert_equal(hash[:day], 4)
    end
  end
end
