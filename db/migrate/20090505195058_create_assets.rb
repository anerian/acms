class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :key
      t.string :ext
      t.timestamps
    end

    add_index :assets, :key

    create_table :assets_pages, :id => false do|t|
      t.integer :asset_id
      t.integer :page_id
    end

    add_index :assets_pages, [:asset_id,:page_id]
  end

  def self.down
    drop_table :assets
  end
end
