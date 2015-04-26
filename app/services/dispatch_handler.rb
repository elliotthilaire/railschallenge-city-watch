require 'subset_sum'

# Handles the dispatching of units for a single type
class DispatchHandler
  def initialize(emergency, type)
    @emergency = emergency
    @type = type
    @severity = emergency.severity(type)
    @ready_responders = Responder.by_type(type).ready_for_dispatch.order(capacity: :asc)

    choose_and_dispatch_units
  end

  private

  def choose_and_dispatch_units
    # no severity, don't dispatch any units
    return if @severity == 0

    # too severe to handle, dispatch all units
    if @severity >= @ready_responders.sum(:capacity)
      responders = @ready_responders
      dispatch_units(responders)
      return
    end

    # try dispatching with one unit
    # look for an exact match, or the next larger
    responder = @ready_responders.capacity_is_at_least(@severity).first
    if responder
      dispatch_unit(responder)
      return
    end

    # find a set of units to dispatch
    responders = find_set_of_responders
    dispatch_units(responders) if responders

    # FIXME: responders = [8,2,3,4] severity = 9
    # This example scenario will not be handled correctly because find_set_of_responders will
    # not find an exact match. Is it better to dispatch [8,2] or [2,3,4] ?
    # This is not required to make current test suite pass, hence has not been implemented.
    # New test with desired behaviour should be created and then find_set_of_responders modified.
  end

  def dispatch_unit(responder)
    responder.update(emergency_code: @emergency.code)
  end

  def dispatch_units(responders)
    responders.update_all(emergency_code: @emergency.code)
  end

  def find_set_of_responders
    # get an array of available capacities e.g. [4,3,5,2]
    array_of_available_capacities = @ready_responders.collect(&:capacity)

    # use subset_sum gem to find an exact solution.
    # it returns an array of capacities whose sum matches the severity
    # e.g. capacities = [5,4,3,1], severity = 7 would product solution_array = [4,3]
    solution_array = SubsetSum.subset_sum(array_of_available_capacities, @severity)

    # if if a solution doesn't exist, do nothing and return
    # FIXME: ideally this behaviour should be fixed but is not currently required to pass tests.
    return nil unless solution_array

    # return an active record object containing the chosen responders
    # OPTIMIZE: currently turning solutions_array into an array of responder_names
    # then producing an activerecord relation using responder_names
    responder_names = []
    solution_array.each do |capacity|
      responder_names << @ready_responders.find_by(capacity: capacity).name
    end
    @ready_responders.where(name: responder_names)
  end
end
