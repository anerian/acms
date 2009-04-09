class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string :key, :limit => 32
      t.text :value
      t.timestamps
    end
    add_index :options, :key
  end

  def self.down
    drop_table :options
  end
end
