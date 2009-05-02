class Option < ActiveRecord::Base
  class General
    Defaults = {:site_title => "Your Site title",
                :tagline => "Your site tagline",
                :site_url => "http://localhost/",
                :site_email => "yoursite@email.com",
                :timezone => "EST",
                :date_format => "%Y-%M-%D",
                :time_format => "%H:%M:%S",
                :weekstart => "Sunday"}.freeze
  end

  def self.default_general_object
    OpenStruct.new(General::Defaults)
  end
end
