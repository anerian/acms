module PagesHelper
  def theme_path
    '/' + Pathname.new(@theme_path).relative_path_from(Pathname.new(File.join(RAILS_ROOT,'public')))
  end
end
