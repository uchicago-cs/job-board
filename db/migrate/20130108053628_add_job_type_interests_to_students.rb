class AddJobTypeInterestsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :interested_in_internships, :boolean, :default => true
    add_column :students, :interested_in_part_time, :boolean, :default => true
    add_column :students, :interested_in_full_time, :boolean, :default => true
  end
end
