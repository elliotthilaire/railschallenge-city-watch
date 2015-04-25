require 'subset_sum'

class DispatchHandler
  def initialize(emergency, type)
    @emergency = emergency
    @type = type
    @severity = get_severity(type)
    @responders = Responder.by_type(type).ready_for_dispatch

    dispatch_units
  end

  private 

  def dispatch_units

    if @severity == 0
      return
    end

    if  @severity >= @responders.sum(:capacity)
      dispatch_all_units
      return
    end

    use_subset_sum
    
  end

  def update_responder(responder)
    responder.emergency_code = @emergency.code
    responder.save!
  end

  def dispatch_all_units
    @responders.update_all(emergency_code: @emergency.code)
  end

  def use_subset_sum
    # use subset_sum to find best match for units
    # there is currently a known bug that if 
    array_of_available_capacities = @responders.collect { |responder| responder.capacity }
    array_of_suitable_capacities = SubsetSum.subset_sum(array_of_available_capacities, @severity)

    if array_of_suitable_capacities
      array_of_suitable_capacities.each do |capacity|
        responder =  @responders.find_by(capacity: capacity)
        update_responder(responder)
      end
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
