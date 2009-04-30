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
    %(<div class="#{status}">#{out}</div>)
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
end
