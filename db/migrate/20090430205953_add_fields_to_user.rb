class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :google, :boolean
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :google
    remove_column :users, :name
  end
end
