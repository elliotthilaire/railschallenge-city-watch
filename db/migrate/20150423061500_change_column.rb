class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column_null :responders, :on_duty, false
  	change_column_default :responders, :on_duty, false
  end
end
