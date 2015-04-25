class DispatchRouter
  def initialize(emergency)
    @emergency = emergency
    types = %w(Fire Police Medical)
    types.each do |type|
      DispatchHandler.new(emergency, type)
    end
    set_full_response
  end

  private

  def set_full_response
    types = %w(Fire Police Medical)
    array = types.collect do |type|
      get_severity(type) <= @emergency.responders.by_type(type).sum(:capacity)
    end

    return if array.all?
    @emergency.full_response = true
    @emergency.save
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
