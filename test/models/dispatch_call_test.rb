require 'test_helper'

class DispatchCallTest < ActiveSupport::TestCase

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_responds_to_one
    responder = FactoryGirl.create(:responder, type: 'Fire', capacity: 3, on_duty: true)
    emergency = FactoryGirl.create(:emergency, fire_severity: 3)
    d = DispatchCall.new(emergency)

    assert_equal 1, Emergency.find_by(code: emergency.code).responders.count
  end

end
