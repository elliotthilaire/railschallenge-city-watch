require 'subset_sum'

# Handles the dispatching of units for a single type
class DispatchHandler
  def initialize(emergency, type)
    @emergency = emergency
    @type = type
    @severity = emergency.severity(type)
    @responders = Responder.by_type(type).ready_for_dispatch.order(capacity: :asc)

    dispatch_units
  end

  private

  def dispatch_units
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
      update_responder(responder)
      return
    end

    # try dispatching a set of units
    # use subset_sum algorithm http://en.wikipedia.org/wiki/Subset_sum_problem
    # there's a gem for that
    try_subset_sum

    # FIXME: responders = [5, 3], severity = 7
    # The above scenario will not be handled correctly because the subset_sum
    # algorithm will not find an exact match. This is not required to make current
    # test suite pass, hence is not implemented. A new test should be written and then
    # this feature added. Clarification is required on how to handle more complex set.
  end

  def update_responder(responder)
    responder.emergency_code = @emergency.code
    responder.save!
  end

  def dispatch_all_units
    @responders.update_all(emergency_code: @emergency.code)
  end

  def try_subset_sum
    # FIXME: use subset_sum to find best match for units
    # there is currently a known bug that if
    # subset doesnt have an exact solution nothing will happen
    array_of_available_capacities = @responders.collect(&:capacity)
    array_of_suitable_capacities = SubsetSum.subset_sum(array_of_available_capacities, @severity)

    # if this can't find a solution, return false
    return false unless array_of_suitable_capacities
    array_of_suitable_capacities.each do |capacity|
      responder =  @responders.find_by(capacity: capacity)
      update_responder(responder)
    end

    # nice.. it worked
    true
  end
end
