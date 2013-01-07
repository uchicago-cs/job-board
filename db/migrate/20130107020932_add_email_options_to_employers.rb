class AddEmailOptionsToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :alert_on_approve, :boolean, :default => true
    add_column :employers, :alert_on_reject, :boolean, :default => true
    add_column :employers, :alert_on_changes_needed, :boolean, :default => true
    add_column :employers, :digests, :boolean, :default => false
  end
end
