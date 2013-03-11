class AddInterestedInEntrepreneurialToStudents < ActiveRecord::Migration
  def change
    add_column :students, :interested_in_entrepreneurial, :boolean, :default => true
  end
end
