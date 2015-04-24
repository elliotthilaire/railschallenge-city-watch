class Responder < ActiveRecord::Base
  # 'type' is reserved as a column name
  alias_attribute :type, :type_of

  scope :by_type, -> (type) { where(type: type) }
  scope :available, -> { where(emergency_code: nil) }
  scope :on_duty, -> { where(on_duty: true)}
  scope :ready_for_dispatch, -> { available.on_duty }

  validates :name,  uniqueness: true
  validates :name, :type, :capacity, presence: true
  validates :capacity, inclusion: 1..5
end
