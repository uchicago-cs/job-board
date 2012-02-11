class FixJobType < ActiveRecord::Migration
  def up
    rename_column :job_postings, :type, :jobtype
  end

  def down
  end
end
