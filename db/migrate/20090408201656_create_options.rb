class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.string  :key, :limit => 32
      t.integer :opt_type, :default => 0
      t.integer :i_value
      t.string  :ss_value
      t.text    :s_value
      t.timestamps
    end
    add_index :options, :key

    execute("insert into options (`key`,opt_type,ss_value) values('active_theme',1,'default')")
  end

  def self.down
    drop_table :options
  end
end
