require_relative 'test_helper'
require 'date'

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

  def test_formatted_name_auto_generation
    @card.name = { first_name: 'Jane', last_name: 'Smith' }

    assert_equal(@card.formatted_name, 'Jane Smith')
  end

  def test_formatted_name_setter
    @card.formatted_name = 'Dr. John Doe Jr.'

    assert_equal(@card.formatted_name, 'Dr. John Doe Jr.')
  end

  def test_formatted_name_in_output
    @card.name = { first_name: 'John', last_name: 'Doe' }
    @card.formatted_name = 'Dr. John Doe Jr.'

    output = @card.to_s
    assert_equal(output.include?('FN:Dr. John Doe Jr.'), true)
  end

  def test_formatted_name_auto_generation_in_output
    @card.name = { first_name: 'Jane', last_name: 'Smith' }

    output = @card.to_s
    assert_equal(output.include?('FN:Jane Smith'), true)
  end

  def test_parsing_formatted_name
    data = "BEGIN:VCARD\r\nVERSION:3.0\r\nN:Doe;John;;;\r\nFN:Dr. John Doe Jr.\r\nEND:VCARD"

    vcard = Valerie::Card.parse(data).first
    assert_equal(vcard.formatted_name, 'Dr. John Doe Jr.')
  end

  def test_parsing_address_from_string
    data = "BEGIN:VCARD\r\nVERSION:3.0\r\nN:Smith;Jane;;;\r\nADR;TYPE=work:;;123 Main St;New York;NY;10001;USA\r\nEND:VCARD"

    vcard = Valerie::Card.parse(data).first
    assert_equal(vcard.addresses.count, 1)
    assert_equal(vcard.addresses.first.to_h[:street_address], '123 Main St')
    assert_equal(vcard.addresses.first.to_h[:locality], 'New York')
    assert_equal(vcard.addresses.first.to_h[:region], 'NY')
    assert_equal(vcard.addresses.first.to_h[:postal_code], '10001')
  end

  def test_complete_vcard_generation
    @card.name = { first_name: 'John', last_name: 'Doe', middle_name: 'Michael' }
    @card.formatted_name = 'John Michael Doe'
    @card.organization = { name: 'Acme Corp', department: 'Engineering' }
    @card.birthday = Date.new(1990, 5, 15)
    @card.gender = 'male'

    @card.emails.add('john@example.com', type: 'work')
    @card.emails.add('john.doe@personal.com', type: 'home', position: 2)

    @card.phones.add('+1-555-123-4567', type: 'work')
    @card.phones.add('+1-555-987-6543', type: 'cell', position: 2)

    @card.addresses.add(
      post_office_box: '',
      extended_address: 'Suite 100',
      street_address: '123 Business Ave',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA'
    )

    output = @card.to_s

    # Verify all fields are present
    assert_equal(output.include?('N:Doe;John;Michael;;'), true)
    assert_equal(output.include?('FN:John Michael Doe'), true)
    assert_equal(output.include?('ORG:Acme Corp;Engineering'), true)
    assert_equal(output.include?('BDAY:1990-05-15'), true)
    assert_equal(output.include?('GENDER:M'), true)
    assert_equal(output.include?('EMAIL'), true)
    assert_equal(output.include?('TEL'), true)
    assert_equal(output.include?('ADR'), true)
    assert_equal(output.include?('123 Business Ave'), true)
  end

  def test_parsing_complete_vcard
    data = <<~VCARD.gsub("\n", "\r\n")
      BEGIN:VCARD
      VERSION:3.0
      PRODID:-//Valerie www.hellotext.com//EN
      N:Doe;John;Michael;;
      FN:John Michael Doe
      ORG:Acme Corp;Engineering
      BDAY:1990-05-15
      GENDER:M
      EMAIL;PREF=1;TYPE=work:john@example.com
      TEL;PREF=1;TYPE=work:+1-555-123-4567
      ADR;TYPE=work:;Suite 100;123 Business Ave;New York;NY;10001;USA
      END:VCARD
    VCARD

    vcard = Valerie::Card.parse(data).first

    assert_equal(vcard.name.first_name, 'John')
    assert_equal(vcard.name.last_name, 'Doe')
    assert_equal(vcard.formatted_name, 'John Michael Doe')
    assert_equal(vcard.organization.name, 'Acme Corp')
    assert_equal(vcard.organization.department, 'Engineering')
    assert_equal(vcard.birthday.to_date, Date.new(1990, 5, 15))
    assert_equal(vcard.gender.sex, :male)
    assert_equal(vcard.emails.count, 1)
    assert_equal(vcard.phones.count, 1)
    assert_equal(vcard.addresses.count, 1)
  end
end
