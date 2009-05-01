class Page < ActiveRecord::Base
  acts_as_taggable
  has_and_belongs_to_many :categories

  validates_presence_of :title, :slug

  module Status
    DRAFT=0
    PENDING_REVIEW=1
    PUBLISHED=2
  end
end
