# Notify DispatchRouter when emergencies are created or updated
# and it will take appropriate action.
class DispatchRouter
  # Actions to take when a new emergency is created.
  def self.notify_new(emergency)
    # Call the dispatch handler for each emergency type.
    EMERGENCY_TYPES.each { |type| DispatchHandler.new(emergency, type) }
    # Analyse to see if dispatched enough units.
    DispatchAnalyser.new(emergency)
  end

  # Actions to take when emergency is updated.
  def self.notify_update(emergency)
    # Free up responders if emergency is resolved.
    emergency.responders.update_all(emergency_code: nil) if emergency.resolved_at
  end
end
