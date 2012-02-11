class CreatePostingTagsTable < ActiveRecord::Migration
  def up
    create_table :job_postings_tags do |t|
	t.integer :job_posting_id
	t.integer :tag_id
    end

    add_index :job_postings_tags, :job_posting_id
    add_index :job_postings_tags, :tag_id
  end

  def down
  end
end
