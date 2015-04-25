class DispatchRouter
  def initialize(emergency)
    types = %w(Fire Police Medical)
    types.each do |type| 
      DispatchHandler.new(emergency, type)
    end
  end
end
