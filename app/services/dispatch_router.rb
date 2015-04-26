# Informs the appropriate departments of emergencies
class DispatchRouter
  # I think this is actually quite cool
  # There's possibility to easily use different code
  # for different types of emergency dispatch teams.
  def self.notify_new_emergency(emergency)
    # call the dispatch handler for each emergency type
    EMERGENCY_TYPES.each { |type| DispatchHandler.new(emergency, type) }
    # analyse to see if dispatched enough units
    DispatchAnalyser.new(emergency)
  end

  # actions to take when emergency is updated
  def self.notify_update(emergency)
    # free up responders if emergency is resolved
    emergency.responders.update_all(emergency_code: nil) if emergency.resolved_at
  end
end
