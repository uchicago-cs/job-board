class CreateIntermediateTables < ActiveRecord::Migration
  def change
    create_table :postings_tags do |t|
      t.integer :posting_id
      t.integer :tag_id
    end

    create_table :students_tags do |t|
      t.integer :student_id
      t.integer :tag_id
    end
  end
end
