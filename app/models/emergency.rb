class Emergency < ActiveRecord::Base
  validates :code,  uniqueness: true
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :fire_severity, :police_severity, :medical_severity, numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, foreign_key: :emergency_code, primary_key: :code

  def full_response
    types = %w(Fire Police Medical)
    array = types.collect do |type|
      get_severity(type) <= responders.by_type(type).sum(:capacity)
    end
    array.all?
  end

  def get_severity(type)
    case type
    when 'Fire'
      severity = fire_severity
    when 'Police'
      severity = police_severity
    when 'Medical'
      severity = medical_severity
    end
    severity
  end
end
