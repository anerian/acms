require 'ostruct'
class Theme < OpenStruct
  def self.find_by_name(name)
    all.find{|t| t.name == name }
  end
  def self.all
    themes = Dir["#{THEME_ROOT}/*"].reject{|t| File.basename(t) == 'active' or !File.exist?("#{THEME_ROOT}/#{File.basename(t)}/manifest.yml") }
    themes.map{|t|
      begin
        theme = {
          :name => File.basename(t),
          :path => t,
          :url_to_theme => '/' + Pathname.new(t).relative_path_from(Pathname.new(File.join(RAILS_ROOT,'public'))),
          :details => YAML.load_file("#{THEME_ROOT}/#{File.basename(t)}/manifest.yml")
        }
        if Pathname.new(File.expand_path(t)).realpath == Pathname.new(File.expand_path(THEME_PATH)).realpath
          theme[:active] = true
        end
        self.new(theme)
      rescue => e
        self.new({
          :name => File.basename(t),
          :path => t,
          :error => true,
          :message => e.message
        })
      end
    }
  end

  def initialize(opts)
    super
  end

  def activate!
    File.unlink(THEME_PATH)
    File.symlink(self.path,THEME_PATH)
  end

end
