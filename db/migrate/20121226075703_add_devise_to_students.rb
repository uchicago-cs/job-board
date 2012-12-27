class AddDeviseToStudents < ActiveRecord::Migration
  def self.up
    change_table(:students) do |t|
      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :students, :email,                :unique => true
    # add_index :students, :confirmation_token,   :unique => true
    # add_index :students, :unlock_token,         :unique => true
    # add_index :students, :authentication_token, :unique => true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
