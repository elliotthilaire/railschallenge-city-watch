class AddIndexToResponders < ActiveRecord::Migration
  def change
    add_index :responders, :name
    add_index :responders, :emergency_code
  end
end
