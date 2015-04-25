class AddIndexToEmergencies < ActiveRecord::Migration
  def change
    add_index :emergencies, :code
  end
end
