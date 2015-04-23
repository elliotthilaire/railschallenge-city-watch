json.responder do
  json.emergency_code nil
  json.type @responder.type
  json.name @responder.name
  json.capacity @responder.capacity
  json.on_duty false
end
