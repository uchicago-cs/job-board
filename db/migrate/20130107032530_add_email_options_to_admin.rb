class AddEmailOptionsToAdmin < ActiveRecord::Migration
  def change
    add_column :students, :alert_on_new_employer, :boolean, :default => true
    add_column :students, :alert_on_new_posting, :boolean, :default => true
    add_column :students, :alert_on_updated_posting, :boolean, :default => true
    add_column :students, :alert_on_my_updated_posting, :boolean, :default => true
    add_column :students, :digests, :boolean, :default => false
  end
end
