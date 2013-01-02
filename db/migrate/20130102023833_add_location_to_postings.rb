class AddLocationToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :location, :string
  end
end
