class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.references :game, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
