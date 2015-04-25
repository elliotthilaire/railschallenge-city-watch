require 'subset_sum'

class DispatchCall

  # completly handles an emergency to best of ability
  # takes in an emergency
  def initialize(emergency)
    @emergency = emergency

    # this is set to true if there are not enough units available.
    @inadequate_dispatch = nil
    
    dispatch_units

    unless @inadequate_dispatch
      @emergency.full_response = true
      @emergency.save
    end
  end

  private
 
  def dispatch_units
  	types = %w(Fire Police Medical)
  	types.each do |type| 
      dispatch_units_of_type(type)
    end
  end

  def dispatch_units_of_type(type)
  	severity = get_severity(type)
    responders = Responder.by_type(type).ready_for_dispatch

    # if zero severity, dispatch no units and end here
    return if severity == 0

    # if severity too great dispatch all units
    if severity >= responders.sum(:capacity)
      dispatch_all_units(responders)
      @inadequate_dispatch = true
      return
    end

    # use subset_sum to find best match for units
    # there is currently a known bug that if 
    capacities = responders.collect { |responder| responder.capacity }
    array_of_suitables = SubsetSum::subset_sum(capacities, severity)
  
    if array_of_suitables
      array_of_suitables.each do |capacity|
        responder = Responder.by_type(type).ready_for_dispatch.find_by(capacity: capacity)
        update_responder(responder)
      end
    end
  end

  def dispatch_all_units(responders)
    responders.each do |responder|
      update_responder(responder)
    end
  end

  def update_responder(responder)
    responder.emergency_code = @emergency.code
    responder.save!
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