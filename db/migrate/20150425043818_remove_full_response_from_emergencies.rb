class RemoveFullResponseFromEmergencies < ActiveRecord::Migration
  def change
    remove_column :emergencies, :full_response, :boolean
  end
end
