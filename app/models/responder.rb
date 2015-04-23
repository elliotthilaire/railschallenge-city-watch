class Responder < ActiveRecord::Base

  # 'type' is reserved as a column name
  alias_attribute :type, :type_of

  validates_uniqueness_of :name
  validates_presence_of :name, :type, :capacity


end
