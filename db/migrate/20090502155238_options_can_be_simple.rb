class OptionsCanBeSimple < ActiveRecord::Migration
  def self.up
    drop_table :options
    create_table :options do|t|
      t.string :key, :null => false, :limit => 32
      t.text   :value, :null => false
    end
    add_index :options, :key
  end

  def self.down
    drop_table :options
  end
end
