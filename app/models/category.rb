class Category < ActiveRecord::Base
  acts_as_tree :order => "name"
  
  named_scope :parents, :conditions => {:parent_id => nil}, :include => :children
end
