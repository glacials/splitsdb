class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.belongs_to :category, index: true
      t.belongs_to :user, index: true
      t.string :title
      t.integer :attempts
      t.integer :offset
      t.string :size

      t.timestamps
    end
  end
end
