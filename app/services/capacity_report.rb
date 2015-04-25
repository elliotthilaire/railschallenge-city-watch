class CapacityReport
  def self.generate
    capacity_report = {}
    # get the unique types
    types = %w(Fire Medical Police)
    # generate as a hash of arrays
    types.each do |type|
      capacity_report[type] = generate_report_for_type(type)
    end
    # return the finished report
    capacity_report
  end

  def generate_report_for_type(type)
    responders = Responder.by_type(type)
    [
      responders.sum(:capacity),
      responders.available.sum(:capacity),
      responders.by_type(type).on_duty.sum(:capacity),
      responders.by_type(type).ready_for_dispatch.sum(:capacity)
    ]
  end
end
