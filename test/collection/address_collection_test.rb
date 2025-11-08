require_relative '../test_helper'

class AddressCollectionTest < Minitest::Test
  def setup
    @collection = Valerie::Collection::AddressCollection.new
  end

  def test_add_address_as_hash
    address = @collection.add(
      post_office_box: '',
      extended_address: '',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA'
    )

    assert_instance_of(Valerie::Address, address)
    assert_equal(address.to_h[:street_address], '123 Main St')
    assert_equal(address.to_h[:locality], 'New York')
  end

  def test_add_address_as_address_object
    address = Valerie::Address.new(
      post_office_box: '',
      extended_address: '',
      street_address: '456 Oak Ave',
      locality: 'Los Angeles',
      region: 'CA',
      postal_code: '90001',
      country: 'USA'
    )

    added = @collection.add(address)

    assert_equal(added.to_h[:street_address], '456 Oak Ave')
    assert_equal(@collection.count, 1)
  end

  def test_add_multiple_addresses_with_positions
    # Add first address without position (gets position 1)
    @collection.add(
      post_office_box: '',
      extended_address: '',
      street_address: '456 Oak Ave',
      locality: 'Los Angeles',
      region: 'CA',
      postal_code: '90001',
      country: 'USA',
      position: 2
    )

    # Add second address with position 1 (should be first)
    @collection.add(
      post_office_box: '',
      extended_address: '',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA',
      position: 1
    )

    assert_equal(@collection.count, 2)
    # Second address should be first due to position: 1
    assert_equal(@collection.first.to_h[:street_address], '123 Main St')
    assert_equal(@collection.first.position, 1)
    assert_equal(@collection.to_a.last.to_h[:street_address], '456 Oak Ave')
  end

  def test_collection_enumerable
    @collection.add(
      post_office_box: '',
      extended_address: '',
      street_address: '123 Main St',
      locality: 'New York',
      region: 'NY',
      postal_code: '10001',
      country: 'USA'
    )

    @collection.add(
      post_office_box: '',
      extended_address: '',
      street_address: '456 Oak Ave',
      locality: 'Los Angeles',
      region: 'CA',
      postal_code: '90001',
      country: 'USA'
    )

    cities = @collection.map { |addr| addr.to_h[:locality] }
    assert_equal(cities, ['New York', 'Los Angeles'])
  end
end
