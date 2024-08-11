require 'test_helper'

class NameTest < Minitest::Test
  def test_initialize_with_hash
    Milday::Name.new(first_name: 'Ahmed', last_name: 'Khattab').tap do |name|
      assert_equal(name.to_h[:first_name], 'Ahmed')
      assert_equal(name.to_h[:last_name], 'Khattab')
    end
  end
  
  def test_initialize_with_string
    Milday::Name.new('Ahmed Khattab').tap do |name|
      assert_equal(name.to_h[:first_name], 'Ahmed')
      assert_equal(name.to_h[:last_name], 'Khattab')
    end
  end
end
