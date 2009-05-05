require 'curb'
require 'ostruct'
require 'yaml'
# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Uploader
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/upload-initiate/
      request = Rack::Request.new(env)

      begin
        referer = URI.parse(request.params["referer"])
      rescue => e
        return [500, {'Content-Type' => 'text/plain'}, e.message]
      end
      config = Option.load_by_key("media_info")

      referer_url = referer.scheme + '://' + referer.host
      referer_url += ':' + referer.port.to_s if referer.port != 80
      signature = Base64.encode64(Digest::SHA1.hexdigest(config.site_key + referer_url + config.site_secret + env["QUERY_STRING"])).strip

      url = "http://anerian.ws/api/s/#{config.site_key}?" + env["QUERY_STRING"]

      c = Curl::Easy.http_post(url, Curl::PostField.content('signature', signature))

      hdrs = c.header_str.split("\r\n")
      status_line = hdrs.shift
      headers = {}
      hdrs.each do|line|
        key, value = line.split(':')
        headers[key] = value
      end
      [c.response_code, headers, c.body_str]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
