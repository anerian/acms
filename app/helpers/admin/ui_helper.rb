module Admin::UiHelper
  def content_given?(name)
    content = instance_variable_get("@content_for_#{name}")
    !content.nil?
  end
  
  def custom_wrapper(&block)
    
  end
  
  def post_box(title, options = {}, &block)
    options[:title] = title
    options[:content] = capture(&block)
    options[:id] ||= ''
    options[:class_name] ||= ''
    
    concat(render(:partial => 'admin/ui/postbox', :locals => options))
  end
end