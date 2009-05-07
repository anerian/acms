class Category < ActiveRecord::Base
  acts_as_tree :order => "name"
  before_save :valid_parent
  has_and_belongs_to_many :pages
  
  named_scope :parents, :conditions => {:parent_id => nil}, :include => {:children => [:parent]}
  
  def valid_parent
    self.parent_id = nil if parent_id == -1
  end
end
