# creates an array [number of fully responded emergency, total number emergencies ]
class ResponseReport
  def self.generate
    [
      Emergency.where(full_response: true).count,
      Emergency.count
    ]
  end
end
