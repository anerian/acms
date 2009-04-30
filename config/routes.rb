ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.namespace :admin do|admin|
    admin.resources :pages, :member => {:delete => :get}
    admin.resources :options, :member => {:delete => :get}, :collection => { :general => [:get,:post], :writing => [:get,:post], :reading => [:get,:post]}
    admin.resources :categories, :member => {:delete => :get}
    admin.resources :tags, :member => {:delete => :get}
    admin.resources :assets, :member => {:delete => :get}
    admin.resources :themes, :member => {:delete => :get}, :collection => { :widgets => :get }
    admin.resources :links, :member => {:delete => :get}
    admin.resources :users, :member => {:delete => :get}
    admin.root :controller => 'dash'
    admin.tools 'admin/tools', :controller => 'tools'
    admin.import_tools 'admin/tools/import', :controller => 'tools', :action => 'import'
    admin.export_tools 'admin/tools/export', :controller => 'tools', :action => 'export'
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'pages', :action => 'show'

  # named user routes
  map.register 'register', :controller => "users", :action => "new"

  map.admin_login   'admin/login',   :controller => 'admin/user_sessions',        :action => 'login',  :conditions => { :method => :get }

  map.login    'login',    :controller => "user_sessions", :action => "new"
  map.logout   'logout',   :controller => "user_sessions", :action => "destroy"

  map.resources :users
  map.resource  :account, :controller => "users"
  map.resource  :user_session

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
