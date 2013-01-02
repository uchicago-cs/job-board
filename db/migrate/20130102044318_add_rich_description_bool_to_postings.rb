class AddRichDescriptionBoolToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :rich_description, :boolean
  end
end
