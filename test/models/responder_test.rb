require 'test_helper'

class ResponderTest < ActiveSupport::TestCase
  def setup
  end

  def responder
    @responder ||= FactoryGirl.create(:responder)
  end

  def test_valid_factory
    assert responder.valid?
  end
end
