class ChangeLoginToCnet < ActiveRecord::Migration
  def change
    rename_column :users, :login, :cnet
  end
end
