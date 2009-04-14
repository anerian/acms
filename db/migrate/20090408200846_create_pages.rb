class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :slug, :limit => 128
      t.text :content
      t.integer :user_id
      t.integer :parent_id
      t.integer :status, :default => 0
      t.datetime :published_at
      t.timestamps
    end
    add_index :pages, :status
    add_index :pages, :slug
  end

  def self.down
    drop_table :pages
  end
end
