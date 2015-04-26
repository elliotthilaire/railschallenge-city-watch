# Notify DispatchRouter when emergencies are created or updated
# and it will take appropriate action.
class DispatchRouter
  # actions to take when a new emergency is created
  def self.notify_new(emergency)
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
