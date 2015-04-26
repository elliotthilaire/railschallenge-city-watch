class Emergency < ActiveRecord::Base
  attr_reader :severity

  validates :code,  uniqueness: true
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates :fire_severity, :police_severity, :medical_severity, numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, foreign_key: :emergency_code, primary_key: :code

  # Lookup the correct severity column.
  # TODO: Make this work for future unknown types.
  def severity(type)
    case type
    when 'Fire'
      fire_severity
    when 'Police'
      police_severity
    when 'Medical'
      medical_severity
    end
  end
end
