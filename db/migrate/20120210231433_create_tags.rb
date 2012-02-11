class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tagtype

      t.timestamps
    end
  end
end
