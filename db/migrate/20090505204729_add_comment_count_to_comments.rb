class AddCommentCountToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :comment_count, :int, :default => 0
  end

  def self.down
    remove_column :comments, :comment_count
  end
end
