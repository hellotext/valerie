require 'test_helper'

class VCardTest < Minitest::Test
  def initialize(name)
    super
    @card = Milday::VCard.new
  end
  
  def test_setting_name_with_hash_parameter
    @card.name = { first_name: 'John', last_name: 'Doe' }
    
    assert_equal(@card.name.first_name, 'John')
    assert_equal(@card.name.last_name, 'Doe')
  end
  
  def test_setting_name_with_string_parameter
    @card.name = 'Adam Hull'
    
    assert_equal(@card.name.first_name, 'Adam')
    assert_equal(@card.name.last_name, 'Hull')
  end
  
  def test_setting_organization_with_hash
    @card.organization = { name: 'Hellotext', department: 'Product Development' }
    
    assert_equal(@card.organization.name, 'Hellotext')
    assert_equal(@card.organization.department, 'Product Development')
  end
  
  def test_setting_organization_with_string
    @card.organization = ['Hellotext', 'Product Development']
    
    assert_equal(@card.organization.name, 'Hellotext')
    assert_equal(@card.organization.department, 'Product Development')
  end
  
  def test_setting_gender_with_valid_identifier
    assert_runs_without_errors do
      @card.gender = 'Male'
      assert_equal(@card.gender.sex, :male)
    end
  end
  
  def test_setting_gender_with_invalid_identifier
    assert_raises(ArgumentError) do
      @card.gender = 'invalid-identifier'
    end
  end
end
