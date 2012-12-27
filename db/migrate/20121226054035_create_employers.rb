class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :url
      t.string :company
      t.text :note_to_reviewer
      t.boolean :approved
      t.timestamps
    end
  end
end
