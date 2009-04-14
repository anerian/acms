class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false, :limit => 128
      t.string :name, :null => false, :limit => 128
      t.string :salt, :null => false
      t.string :hashed_password, :null => false, :limit => 40
      t.string :remember_token
      t.string :remember_token_expires
      t.timestamps
    end
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
