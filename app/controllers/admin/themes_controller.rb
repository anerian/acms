class Admin::ThemesController < Admin::AdminController
  def index
    @themes = Dir["#{THEME_ROOT}/*"].reject{|t| File.basename(t) == 'active' or !File.exist?("#{THEME_ROOT}/#{File.basename(t)}/manifest.yml") }
    @themes.map!{|t|
      begin
        {
          :name => File.basename(t),
          :path => t,
          :url_to_theme => '/' + Pathname.new(t).relative_path_from(Pathname.new(File.join(RAILS_ROOT,'public'))),
          :details =>YAML.load_file("#{THEME_ROOT}/#{File.basename(t)}/manifest.yml")
        } 
      rescue => e
        {
          :name => File.basename(t),
          :path => t,
          :error => true,
          :message => e.message
        } 
      end
    }
  end

  def widgets
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

end
