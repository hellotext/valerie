require_relative '../test_helper'

class PhoneCollectionTest < Minitest::Test
  def setup
    @collection = Milday::Collection::PhoneCollection.new
  end
  
  def test_add_phone_as_string
    phone = @collection.add('1234567890', type: :work)
    
    assert_instance_of(Milday::Phone, phone)
    
    assert_equal(phone.number, '1234567890')
    assert_equal(phone[:type], :work)
  end
  
  def test_add_phone_as_phone_object
    phone = Milday::Phone.new('1234567890', type: :work)
    @collection.add('0987654321', type: :home)
    
    assert_equal(@collection.add(phone).position, 2)
  end
end
