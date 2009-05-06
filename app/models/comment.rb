class Comment < ActiveRecord::Base
  acts_as_commentable
  belongs_to :commentable, :polymorphic => true
end