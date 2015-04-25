# Analyses a dispatch and sets full response to true, or not
class DispatchAnalyser
  def initialize(emergency)
    # get arrary e.g. [ true, false, true ]
    array = EMERGENCY_TYPES.collect do |type|
      emergency.severity(type) <= emergency.responders.by_type(type).sum(:capacity)
    end

    # update full response if full response for all type
    emergency.update(full_response: true) if array.all?
  end
end
