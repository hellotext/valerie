require_relative '../test_helper'

class EmailCollectionTest < Minitest::Test
  def setup
    @collection = Valerie::Collection::EmailCollection.new
  end
  
  def test_add_email_as_string
    email = @collection.add('ahmed@hellotext.com', type: :work)
    
    assert_instance_of(Valerie::Email, email)
    
    assert_equal(email.address, 'ahmed@hellotext.com')
    assert_equal(email[:type], :work)
  end
  
  def test_add_email_as_hash
    email = @collection.add({ address: 'john@hellotext.com', type: :home })
    
    assert_instance_of(Valerie::Email, email)
    assert_equal(email.address, 'john@hellotext.com')
    assert_equal(email[:type], :home)
  end
  
  def test_add_email_as_email_object
    email = Valerie::Email.new(address: 'ahmed@hellotext.com', type: :work)
    @collection.add({ address: 'john@hellotext.com', type: :home })
    
    assert_equal(@collection.add(email).position, 2)
  end
  
  def test_setting_the_position_for_each_inserted_email
    email = @collection.add('ahmed@hellotext.com')
    email2 = @collection.add('john@hellotext.com')
    
    assert_equal(email[:position], 1)
    assert_equal(email2[:position], 2)
  end
end
