class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string :key, :limit => 32
      t.text :value
      t.integer :user_id
      t.timestamps
    end
    add_index :options, :key
    add_index :options, :user_id
  end

  def self.down
    drop_table :options
  end
end
