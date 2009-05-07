class Link < ActiveRecord::Base
  belongs_to :asset

  acts_as_taggable

  validates_presence_of :url, :title

  def to_liquid
    {'title' => self.title, 'url' => self.url}
  end
end
