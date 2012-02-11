class CreateUserTagsTable < ActiveRecord::Migration
  def up
    create_table :tags_users do |t|
	t.integer :user_id
	t.integer :tag_id
    end

    add_index :tags_users, :user_id
    add_index :tags_users, :tag_id
  end

  def down
  end
end
