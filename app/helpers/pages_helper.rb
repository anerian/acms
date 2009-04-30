module PagesHelper
  def theme_path
    '/' + Pathname.new(THEME_PATH).relative_path_from(Pathname.new(File.join(RAILS_ROOT,'public')))
  end
end
