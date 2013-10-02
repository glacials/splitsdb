class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.string :name
      t.references :run, index: true
      t.integer :old
      t.integer :best_run
      t.integer :best_segment

      t.timestamps
    end
  end
end
