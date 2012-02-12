class AddPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :Full_Time, :boolean
    add_column :users, :Part_Time, :boolean
    add_column :users, :Internship, :boolean
  end
end
