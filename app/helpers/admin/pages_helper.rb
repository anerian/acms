module Admin::PagesHelper  
  def category_children(page, category)
    return if category.children.blank?
    
    out = category.children.map{|c|
      html = content_tag(:li, content_tag(:label, check_box_tag("page[category_ids][]", c.id, page.categories.include?(c)) + c.name))
      html << category_children(page, c) unless c.children.blank?
      html
    }
    content_tag(:ul, out, :class => 'children')
  end
  
  def select_for_categories(options = {})
    options_for_select = content_tag(:option, 'Parent category', :value => '-1')
    options_for_select << Category.parents.map{|c| option_for_categories(c)}.join('')
    
    content_tag(:select, options_for_select, :id => options[:id], :name => options[:name], :class => options[:class_name])
  end
  
  def option_for_categories(category, level = 0)
    prefix = ("&nbsp;&nbsp;" * level)
    out = content_tag(:option, prefix + category.name, :value => category.id)
    out << category.children.map{|c| option_for_categories(c, (level + 1))}.join('')
    out
  end
end
