json.array!(@responders) do |responder|
  json.extract! responder, :id, :emergency_code, :type_of, :name, :capacity, :on_duty
  json.url responder_url(responder, format: :json)
end
