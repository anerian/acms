THEME_ROOT="#{RAILS_ROOT}/public/themes"
THEME_PATH="#{THEME_ROOT}/active"
THEME_VIEWS="#{THEME_PATH}/views"

ActionController::Base.view_paths.unshift THEME_VIEWS