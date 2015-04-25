# Calls the DispatchHandler for each type of emergency
class DispatchRouter
  def initialize(emergency)
    # call the dispatch handler for each emergency type
    EMERGENCY_TYPES.each { |type| DispatchHandler.new(emergency, type) }
    # analyse to see if dispatched enough units
    DispatchAnalyser.new(emergency)
  end
end
