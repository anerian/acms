module Admin::UiHelper
  def content_given?(name)
    content = instance_variable_get("@content_for_#{name}")
    !content.nil?
  end
  
  def custom_wrapper(&block)
    
  end
  
  def post_box(title, &block)
    concat(render(:partial => 'admin/ui/postbox', :locals => {:title => title, :content => capture(&block)}))
  end
end