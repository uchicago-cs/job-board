class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.string :title
      t.text :description
      t.text :comments
      t.integer :jobtype
      t.string :contact
      t.string :company
      t.datetime :active_until
      t.integer :state
      t.string :url
      t.integer :employer_id
      t.timestamps
    end
  end
end
