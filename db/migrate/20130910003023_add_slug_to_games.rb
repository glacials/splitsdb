class AddSlugToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :slug, :string
    add_index :games, :slug, :unique => true
  end
  def self.down
    remove_column :games, :slug
  end
end
