class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :passwd
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :type

      t.timestamps
    end
  end
end
