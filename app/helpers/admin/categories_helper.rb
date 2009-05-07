module Admin::CategoriesHelper
  def categories_list(categories = Category.roots, level = 0, &block)
    html = categories.map{|category| 
      tr = capture(category, level, &block)
      tr << categories_list(category.children, level + 1, &block) unless category.children.blank?
      tr
    }.join('')
    
    concat(html) if level == 0
    html
  end
end
