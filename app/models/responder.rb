class Responder < ActiveRecord::Base
  # 'type' is reserved as a column name
  alias_attribute :type, :type_of

  validates :name,  uniqueness: true
  validates :name, :type, :capacity, presence: true
  validates :capacity, inclusion: 1..5
end
