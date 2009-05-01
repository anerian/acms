class CreateCategoriesPages < ActiveRecord::Migration
  def self.up
    create_table :categories_pages, :id => false do |t|
      t.column :category_id, :integer, :null => false
      t.column :page_id, :integer, :null => false
    end
    add_index :categories_pages, [:category_id, :page_id], :unique => true
  end

  def self.down
    drop_table :categories_pages
  end
end
