require 'rexml/document'

class WordpressImporter
  Fields = ['title','link','pubDate','description','content:encoded', 'category']

  attr_reader :items

  def initialize(filename, *args)
    @doc = REXML::Document.new(File.new(filename))
    @items = []
  end

  def parse_items
    (!@items.blank? && @items) || (@doc.elements.each("//item") do |item|
      @items << Fields.inject({}) do |hash, i| 
        data = item.get_text(i).to_s #to_s changes it from REXML::Text to just Text
        if i == 'pubDate'
          hash[i] = DateTime.parse(data)
        else
          hash[i] = data
        end
        hash
      end
    end)
  end

  def write_out_pages
    # user_id is set to 1. need to remove this user_id requiredness or figure out which id to use
    # add better error handling
    items.each do |item|
      unless page = Page.create(:title => item['title'], :content => item['content:encoded'], 
                                :slug => item['link'], :published_at => item['pubDate'], :user_id => 1)
        raise page.errors
      end
    end
  end

end
