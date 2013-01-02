class ChangePostingContactToMultiline < ActiveRecord::Migration
  def change
    # Using drop + add rather than change to prevent any unwanted option carryovers
    remove_column :postings, :contact
    add_column :postings, :contact, :text
  end
end
