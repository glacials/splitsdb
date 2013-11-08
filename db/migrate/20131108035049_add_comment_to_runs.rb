class AddCommentToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :comment, :string
  end
end
