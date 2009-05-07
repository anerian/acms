module Admin::AdminHelper
  
  def flash_display
    if flash.key?(:success)
      out = flash[:success]
      status = :success
    elsif flash.key?(:notice)
      out = flash[:notice]
      status = :notice
    elsif flash.key?(:error)
      out = flash[:error]
      status = :error
    end
    #logger.debug("status: #{status.inspect} #{flash.inspect}")
    return '' if out.blank?
    %(<div id="message" class="#{status}"><p>#{out}</p></div>)
  end
  
  def toolbar(&block)
    concat render(:partial => 'widgets/toolbar', :locals => { :content => capture(&block) })
  end

  def toolbar_section(type,path=nil,options={},&block)
    use_match = options.delete(:match) if options.key?(:match)
    path = (path || send("admin_#{type}_path"))
    if (use_match and request.path.match(path)) or
       (use_match.is_a?(Regexp) and request.path.match(use_match)) or
       (request.path == path)

      if options.key? :class
        options[:class] += ' current'
      else
        options.merge!({:class => 'current'})
      end
    end
    if options.key? :class
      options[:class] += ' open'
    else
      options.merge!({:class => 'open'})
    end
    link = link_to(t(type), path)
    html = capture(&block)
    concat (
      content_tag(:li, %(<h2><span class="micon #{type}-icon"></span>#{ link }<span class="handle"></span></h2><ul>#{html}</ul>), options)
    )
  end

  def tb_item(title,path, options={})
    link = link_to(t(title),path)
    if request.path == path
      if options.key? :class
        options[:class] += ' selected'
      else
        options.merge!({:class => 'selected'})
      end
    end
    content_tag :li, link, options
  end

  def button_save_or_cancel(title, cancel_path)
    ret = content_tag(:button, title, :value => title, :name => 'submit', :type => 'submit')
    ret << link_to('Cancel', cancel_path, :class => 'alt_button')
    ret
  end

  class ActionView::Helpers::FormBuilder
    def asset(method_name, options ={})
      options[:title] ||= 'Choose an Image'
      options[:id]    ||= "#{@object_name}_#{method_name}"
      options[:name]  ||= "#{@object_name}[#{method_name}]"
      options[:asset_name] ||= method_name.to_s.gsub(/_id/,'').to_sym
      options[:object] = @object
      options[:basic_type] ||= nil

      @template.render(:partial => 'admin/widgets/asset_picker', :locals => options)
    end
    def rte(method_name, options={})
      options[:textarea] = self.input method_name, :label => options[:label]
      options[:id] ||= "#{@object_name}_#{method_name}"
      
      @template.render(:partial => 'admin/widgets/rich_text_field', :locals => options)
    end
    
    def tags(method_name, options = {})
      options[:id] ||= "#{@object_name}_#{method_name}"
      options[:name]  ||= "#{@object_name}[#{method_name}]"
      options[:input] = self.hidden_field method_name
      options[:label] = self.label method_name
      options[:tags] = @object.respond_to?(:tag_list) ? @object.tag_list.join(',') : ''
      
      @template.render(:partial => 'admin/widgets/tag_picker', :locals => options)
    end
  end

end
