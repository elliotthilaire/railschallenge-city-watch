module RespondersHelper
  # turn responders into array of names
  def responder_names(responders)
    responders.collect(&:name)
  end
end
