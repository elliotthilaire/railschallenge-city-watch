class CapacityReport
  def self.generate
    capacity_report = {}
    # get the unique types
    types = Responder.uniq.pluck(:type)
    # generate as a hash of arrays
    types.each do |type|
      capacity_report[type] =
        [
          Responder.by_type(type).sum(:capacity),
          Responder.by_type(type).available.sum(:capacity),
          Responder.by_type(type).on_duty.sum(:capacity),
          Responder.by_type(type).ready_for_dispatch.sum(:capacity)
        ]
    end
    # return the finished report
    capacity_report
  end
end
