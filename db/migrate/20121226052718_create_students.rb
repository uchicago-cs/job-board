class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :cnet
      t.string :email
      t.string :firstname
      t.string :lastname
      t.integer :role
      t.timestamps
    end
  end
end
