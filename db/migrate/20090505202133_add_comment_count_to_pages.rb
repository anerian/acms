class AddCommentCountToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :comment_count, :int, :default => 0
  end

  def self.down
    remove_column :pages, :comment_count
  end
end
