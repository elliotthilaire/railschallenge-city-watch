require 'test_helper'

class DispatchRouterTest < ActiveSupport::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_responds_to_one
    FactoryGirl.create(:responder, type: 'Fire', capacity: 3, on_duty: true)
    emergency = FactoryGirl.create(:emergency, fire_severity: 3)
    DispatchRouter.new(emergency)

    assert_equal 1, Emergency.find_by(code: emergency.code).responders.count
  end

  def test_full_response
    FactoryGirl.create(:responder, type: 'Fire', capacity: 3, on_duty: true)
    emergency = FactoryGirl.create(:emergency, fire_severity: 3)
    DispatchRouter.new(emergency)

    assert Emergency.find_by(code: emergency.code).responders.count
  end

  def test_not_full_response
    FactoryGirl.create(:responder, type: 'Fire', capacity: 1, on_duty: true)
    emergency = FactoryGirl.create(:emergency, fire_severity: 3)
    DispatchRouter.new(emergency)

    refute emergency.full_response
  end
end
