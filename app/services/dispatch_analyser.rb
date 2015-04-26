# Analyse a dispatch and set full_response to true, or not.
class DispatchAnalyser
  def initialize(emergency)
    # Check each emergency type store result in array.
    # e.g. [ true, false, true ]
    array = EMERGENCY_TYPES.collect do |type|
      emergency.severity(type) <= emergency.responders.by_type(type).sum(:capacity)
    end

    # Update full_response if every severity type is handled.
    emergency.update(full_response: true) if array.all?
  end
end
