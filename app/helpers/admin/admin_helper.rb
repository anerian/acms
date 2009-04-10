module Admin::AdminHelper
  
  def toolbar(&block)
    concat render :partial => 'widgets/toolbar', :locals => { :content => capture(&block) }
  end

  def toolbar_section(type,link=nil,options={},&block)
    link = link_to(t(type), (link || send("admin_#{type}_path")))
    html = capture(&block)
    concat (
      content_tag(:li, %(<h2><span class="micon #{type}-icon"></span>#{ link }<span class="handle"></span></h2><ul>#{html}</ul>), options)
    )
  end

  def tb_item(title,path, options={})
    link = link_to(t(title),path)
    content_tag :li, link, options
  end
end
