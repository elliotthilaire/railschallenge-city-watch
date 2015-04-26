module RespondersHelper
  # Turn responders into array of names.
  # e.g. ['F-101', 'F-103', 'F-104']
  def responder_names(responders)
    responders.collect(&:name)
  end
end
