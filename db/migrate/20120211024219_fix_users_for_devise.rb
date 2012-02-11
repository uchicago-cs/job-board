class FixUsersForDevise < ActiveRecord::Migration
  def up
    remove_column :users, :passwd
    change_column :users, :email, :string, {:null => false, :default => ""}
  end

  def down
  end
end
