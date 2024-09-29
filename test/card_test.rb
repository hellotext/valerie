require_relative 'test_helper'

class VCardTest < Minitest::Test
  def initialize(name)
    super
    @card = Valerie::Card.new
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
  
  def test_parsing_array
    data = ['PRODID:-//Hellotext', 'N:Doe;John;;;', "ORG:HelloText;", "TEL;type=CELL:+598 94 000 000"]
    
    Valerie::Card.parse(data).tap do |vcard|
      assert_equal(vcard.name.first_name, 'John')
      assert_equal(vcard.name.last_name, 'Doe')
      
      assert_equal(vcard.organization.name, 'HelloText')
      
      assert_equal(vcard.phones.first.number, '+598 94 000 000')
      assert_equal(vcard.phones.first.options[:type], 'cell')
    end
  end
  
  def test_parsing_string
    data = "BEGIN:VCARD\r\nVERSION:3.0\r\nPRODID:-//Hellotext www.hellotext.com//EN\r\nN:Rosenbaum;Shira;;;\r\nTEL;:+598 94 987 924\r\nEND:VCARD"
    
    Valerie::Card.parse(data).first.tap do |vcard|
      assert_equal(vcard.name.first_name, 'Shira')
      assert_equal(vcard.name.last_name, 'Rosenbaum')
      assert_equal(vcard.phones.first.number, '+598 94 987 924')
    end
  end
end
