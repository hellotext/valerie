require_relative 'test_helper'

class NameTest < Minitest::Test
  def test_initialize_with_hash
    Valerie::Name.new(first_name: 'Ahmed', last_name: 'Khattab').tap do |name|
      assert_equal(name.to_h[:first_name], 'Ahmed')
      assert_equal(name.to_h[:last_name], 'Khattab')
    end
  end
  
  def test_initialize_with_string
    Valerie::Name.new('Ahmed Khattab').tap do |name|
      assert_equal(name.to_h[:first_name], 'Ahmed')
      assert_equal(name.to_h[:last_name], 'Khattab')
    end
  end
end
