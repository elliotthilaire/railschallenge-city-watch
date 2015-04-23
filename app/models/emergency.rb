class Emergency < ActiveRecord::Base
  validates :code,  uniqueness: true
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :fire_severity, :police_severity, :medical_severity, numericality: { greater_than: 0 }
end
