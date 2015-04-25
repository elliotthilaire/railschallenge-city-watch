class Capacity
  # The total capacity of all responders in the city, by type
  def self.get_responder_by_type(type)
    Responder.where(type: type)
  end
end
