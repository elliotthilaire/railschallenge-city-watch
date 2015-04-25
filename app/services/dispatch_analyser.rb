# Analyses a dispatch and sets full response or not
class DispatchAnalyser
  def initialize(emergency)
    @emergency = emergency
    # get arrary e.g. [ true, false, true ]
    array = EMERGENCY_TYPES.collect do |type|
      get_severity(type) <= @emergency.responders.by_type(type).sum(:capacity)
    end

    # if all items in array is true, set emergency full response
    if array.all?
      @emergency.full_response = true
      @emergency.save
    end
  end

  def get_severity(type)
    case type
    when 'Fire'
      severity = @emergency.fire_severity
    when 'Police'
      severity = @emergency.police_severity
    when 'Medical'
      severity = @emergency.medical_severity
    end
    severity
  end
end
