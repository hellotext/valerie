require_relative 'test_helper'

class AddressTest < Minitest::Test
  def test_initialize_with_all_fields
    address = Valerie::Address.new(
      post_office_box: 'PO Box 123',
      extended_address: 'Suite 200',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA'
    )

    assert_equal(address.to_h[:post_office_box], 'PO Box 123')
    assert_equal(address.to_h[:extended_address], 'Suite 200')
    assert_equal(address.to_h[:street_address], '123 Main St')
    assert_equal(address.to_h[:locality], 'New York')
    assert_equal(address.to_h[:region], 'NY')
    assert_equal(address.to_h[:postal_code], '10001')
    assert_equal(address.to_h[:country], 'USA')
  end

  def test_to_s_format
    address = Valerie::Address.new(
      post_office_box: '',
      extended_address: '',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA'
    )

    assert_equal(address.to_s.start_with?('ADR:'), true)
    assert_equal(address.identifier, ';;123 Main St;New York;NY;10001;USA')
  end

  def test_to_s_with_position
    address = Valerie::Address.new(
      post_office_box: '',
      extended_address: '',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA',
      position: 1
    )

    assert_equal(address.to_s, 'ADR;PREF=1:;;123 Main St;New York;NY;10001;USA')
  end

  def test_with_invalid_position
    error = assert_raises(ArgumentError) do
      Valerie::Address.new(
        post_office_box: '',
        extended_address: '',
        street_address: '123 Main St',
        locality: 'New York',
        region: 'NY',
        postal_code: '10001',
        country: 'USA',
        position: -1
      )
    end

    assert_equal(error.message, 'Invalid Position')
  end

  def test_from_s_parsing
    address_string = 'ADR;TYPE=work:PO Box 123;Suite 200;123 Main St;New York;NY;10001;USA'
    address = Valerie::Address.from_s(address_string)

    assert_equal(address.to_h[:post_office_box], 'PO Box 123')
    assert_equal(address.to_h[:extended_address], 'Suite 200')
    assert_equal(address.to_h[:street_address], '123 Main St')
    assert_equal(address.to_h[:locality], 'New York')
    assert_equal(address.to_h[:region], 'NY')
    assert_equal(address.to_h[:postal_code], '10001')
    assert_equal(address.to_h[:country], 'USA')
  end

  def test_from_s_parsing_with_empty_fields
    address_string = 'ADR;TYPE=home:;;456 Oak Ave;Los Angeles;CA;90001;USA'
    address = Valerie::Address.from_s(address_string)

    assert_equal(address.to_h[:post_office_box], '')
    assert_equal(address.to_h[:extended_address], '')
    assert_equal(address.to_h[:street_address], '456 Oak Ave')
    assert_equal(address.to_h[:locality], 'Los Angeles')
  end
end
