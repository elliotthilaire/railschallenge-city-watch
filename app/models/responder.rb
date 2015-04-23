class Responder < ActiveRecord::Base

  # 'type' is reserved as a column name
  alias_attribute :type, :type_of

end
