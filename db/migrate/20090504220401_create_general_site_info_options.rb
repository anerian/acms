class CreateGeneralSiteInfoOptions < ActiveRecord::Migration
  def self.up
    Option.create_default_general_object
  end

  def self.down
    Option.find_by_key('site_info').destroy
  end
end
