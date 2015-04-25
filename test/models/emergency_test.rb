require 'test_helper'

class EmergencyTest < ActiveSupport::TestCase

  def setup
  end

  def emergency
    @emergency ||= FactoryGirl.create(:emergency)
  end

  def test_valid_factory
    assert emergency.valid?
  end



end
