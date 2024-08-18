require_relative 'test_helper'

class OrganizationTest < Minitest::Test
  def test_new_constructor_with_array
    Milday::Organization.new('Hellotext', 'Product Engineer').tap do |org|
      assert_equal(org.name, 'Hellotext')
      assert_equal(org.department, 'Product Engineer')
    end
  end
  
  def test_new_constructor_with_hash
    Milday::Organization.new(name: 'Hellotext', department: 'Product Engineer').tap do |org|
      assert_equal(org.name, 'Hellotext')
      assert_equal(org.department, 'Product Engineer')
    end
  end
  
  def test_from_s
    Milday::Organization.from_s('ORG:Hellotext;Product Engineer').tap do |org|
      assert_equal(org.name, 'Hellotext')
      assert_equal(org.department, 'Product Engineer')
    end
  end
  
  def test_to_s
    Milday::Organization.new(name: 'Hellotext', department: 'Product Engineer').tap do |org|
      assert_equal(org.to_s, 'ORG:Hellotext;Product Engineer')
    end
  end
  
  def test_present_when_name_is_set
    Milday::Organization.new(name: 'Hellotext').tap do |org|
      assert_equal(org.present?, true)
    end
  end
  
  def test_present_when_department_is_set
    Milday::Organization.new(department: 'Product Engineer').tap do |org|
      assert_equal(org.present?, true)
    end
  end
  
  def test_present_when_none_is_set
    Milday::Organization.new.tap do |org|
      assert_equal(org.present?, false)
    end
  end

end
