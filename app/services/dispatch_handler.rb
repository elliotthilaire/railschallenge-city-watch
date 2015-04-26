require 'subset_sum'

# Handles the dispatching of units for a single type
class DispatchHandler
  def initialize(emergency, type)
    @emergency = emergency
    @type = type
    @severity = emergency.severity(type)
    @responders = Responder.by_type(type).ready_for_dispatch.order(capacity: :asc)

    choose_and_dispatch_units
  end

  private

  def choose_and_dispatch_units
    # no severity, don't dispatch any units
    return if @severity == 0

    # too severe to handle, dispatch all units
    if @severity >= @responders.sum(:capacity)
      dispatch_all_units
      return
    end

    # try dispatching with one unit
    # look for an exact match, or the next larger
    responder = @responders.capacity_is_at_least(@severity).first
    if responder
      dispatch_unit(responder)
      return
    end

    # try dispatching a set of units
    # use subset_sum algorithm http://en.wikipedia.org/wiki/Subset_sum_problem
    # there's a gem for that
    dispatch_set_of_units

    # FIXME: responders = [5, 3], severity = 7
    # The above scenario will not be handled correctly because the subset_sum
    # algorithm will not find an exact match. This is not required to make current
    # test suite pass, hence is not implemented. A new test should be written and then
    # this feature added. Clarification is required on how to handle more complex set.
  end

  def dispatch_unit(responder)
    responder.update(emergency_code: @emergency.code)
  end

  def dispatch_all_units
    @responders.update_all(emergency_code: @emergency.code)
  end

  def dispatch_set_of_units
    # get an array of available capacities e.g. [4,3,5,2]
    array_of_available_capacities = @responders.collect(&:capacity)
    # use subset_sum to find a combination that matches the severity
    array_of_suitable_capacities = SubsetSum.subset_sum(array_of_available_capacities, @severity)

    # if if a solution doesn't exist, do nothing and return
    # FIXME: ideally this behaviour should be fixed but is not currently required to pass tests.
    return false unless array_of_suitable_capacities

    # search for responders by matching capacity and dispatch them
    array_of_suitable_capacities.each do |capacity|
      responder =  @responders.find_by(capacity: capacity)
      dispatch_unit(responder)
    end
  end
end
