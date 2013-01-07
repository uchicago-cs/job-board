class AddReviewedByToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :reviewed_by, :integer
  end
end
