class AddEmailOptionsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :alert_on_new_recommendation, :boolean, :default => true
  end
end
