# Calls the DispatchHandler for each type of emergency
class DispatchRouter
  def initialize(emergency)
    types = %w(Fire Police Medical)
    types.each do |type|
      DispatchHandler.new(emergency, type)
    end

    DispatchAnalyser.new(emergency)
  end
end
