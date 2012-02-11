class CreateJobPostings < ActiveRecord::Migration
  def change
    create_table :job_postings do |t|
      t.string :title
      t.text :description
      t.text :comments
      t.string :type
      t.string :contact
      t.string :type
      t.date :deadline
      t.string :state
      t.references :employer
      t.string :url
      t.string :affiliation

      t.timestamps
    end
    add_index :job_postings, :employer_id
  end
end
