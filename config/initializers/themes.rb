THEME_ROOT="#{RAILS_ROOT}/public/themes"
THEME_PATH="#{THEME_ROOT}/active"
THEME_VIEWS="#{THEME_PATH}/views"

ActionController::Base.view_paths.unshift THEME_VIEWS


# TODO: if the app container runs in multiple threads we need this
require 'thread'
require 'ostruct'

THEME_PREVIEW_MUTEX=Mutex.new
