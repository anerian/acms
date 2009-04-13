# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Pages
  THEME_ROOT="#{RAILS_ROOT}/public/themes"

  def self.call(env)
    request = Rack::Request.new(env)
    page = Page.find_by_id(request.params['id'])

    if page.nil?
      case request.path_info 
      when /^\/$/
        render_themed(nil,:home)
      when /^\/categories/
        render_themed(nil,:categories)
      when /^\/tags/
        render_themed(nil,:tags)
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
      end
    else
      render_themed(page,:single)
    end
  rescue => e
    error(500,e)
  end

  def self.error(status,e)
    line_number = nil
    e.backtrace.each do |line|
      if line =~ /^\(erubis\):(\d+)/
        line_number = $1.to_i
        break
      end
    end
    erubis = Erubis::Eruby.new(File.read(File.join(File.dirname(__FILE__),'views', '500.html.erb')))
    [status,{'Content-Type' => 'text/html'}, erubis.result({:error => e, :line_number => line_number})]
  end

  def self.load_theme(page)
    option = Option.find_by_key("active_theme")
    option.ss_value
  end

  def self.render_themed(page,template=:single)
    puts "rendering: #{page.inspect} with #{template.inspect}"
    theme_name = load_theme(page)
    theme_name = 'default' if theme_name.nil?
    theme_path = File.join(THEME_ROOT,theme_name)
    erubis = Erubis::Eruby.new(File.read(File.join(theme_path, template.to_s + '.html.erb')))
    [200, {"Content-Type" => "text/html"}, [erubis.result({:page => page, :theme_root => "/themes/#{theme_name}" } )]]
  end
end
