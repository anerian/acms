class Page < ActiveRecord::Base
  acts_as_commentable
  acts_as_taggable
  has_and_belongs_to_many :categories

  validates_presence_of :title, :slug, :user_id
  
  before_save :set_publish_date
  
  attr_accessor :publish

  module Status
    DRAFT=0
    PENDING_REVIEW=1
    PUBLISHED=2
  end

  def published?
    !published_at.blank?
  end
  
  private
    def set_publish_date
      self.published_at = publish.blank?? nil : Time.now
    end
end
