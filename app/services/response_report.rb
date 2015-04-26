# Generate a report of all emergency responses.
# Return an array [ number_of_emergencies_fully_responded_to, total_number_of_emergencies ]
class ResponseReport
  def self.generate
    [
      Emergency.where(full_response: true).count,
      Emergency.count
    ]
  end
end
