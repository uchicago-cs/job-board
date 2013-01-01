class AddAttachmentAttachmentToPostings < ActiveRecord::Migration
  def self.up
    change_table :postings do |t|
      t.has_attached_file :attachment
    end
  end

  def self.down
    drop_attached_file :postings, :attachment
  end
end
