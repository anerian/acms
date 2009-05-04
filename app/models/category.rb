class Category < ActiveRecord::Base
  acts_as_tree :order => "name"
  before_create :valid_parent
  
  named_scope :parents, :conditions => {:parent_id => nil}, :include => {:children => [:parent]}
  
  def valid_parent
    self.parent_id = nil if parent_id == -1
  end
end
