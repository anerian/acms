class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string  :key, :limit => 32
      t.integer :type, :default => 0
      t.integer :i_value
      t.text    :s_value
      t.timestamps
    end
    add_index :options, :key
  end

  def self.down
    drop_table :options
  end
end
