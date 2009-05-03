module PagesHelper
  def theme_path
    '/' + Pathname.new(@theme_path).relative_path_from(Pathname.new(File.join(RAILS_ROOT,'public')))
  end
  
  def category_children(page, category)
    return if category.children.blank?
    
    out = category.children.map{|c|
      html = content_tag(:li, content_tag(:label, check_box_tag("page[category_ids][]", c.id, page.categories.include?(c)) + c.name))
      html << category_children(page, c) unless c.children.blank?
      html
    }
    content_tag(:ul, out, :class => 'children')
  end
end
