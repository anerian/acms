# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Pages
  def self.call(env)
    request = Rack::Request.new(env)
    page = Page.find_by_id(request.params['id'])

    if page.nil?
      if request.path =~ /^\/$/
        [200, {"Content-Type" => "text/html"}, ["Home page"]]
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found: #{request.path}"]]
      end
    else
      [200, {"Content-Type" => "text/html"}, ["Page: #{page.inspect}"]]
    end
  end
end
