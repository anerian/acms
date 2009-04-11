class Page < ActiveRecord::Base
  module Status
    DRAFT=0
    PENDING_REVIEW=1
    PUBLISHED=2
  end
end
