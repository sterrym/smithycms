Smithy::Engine.routes.draw do
  root :to => 'pages#show'
  scope "/smithy" do
    match '/' => redirect('/smithy/pages')
    match '/login'  => redirect('/'), :as => :login
    match '/logout' => redirect('/'), :as => :logout
    # CMS admin
    resources :assets
    resources :content_blocks
    resources :guides, :only => :show
    resources :pages do
      collection do
        get :order
      end
      resources :contents, :controller => "PageContents", :except => [ :index ] do
        member do
          get :preview
        end
        collection do
          get :order
        end
      end
    end
    resources :templates
    resources :settings
    resource :cache

    # Content Blocks
    resources :contents, :except => :index
    resources :images, :except => :index
  end
  match '/templates/javascripts/*javascript' => 'templates#javascript', :defaults => { :format => 'js' }
  match '/templates/stylesheets/*stylesheet' => 'templates#stylesheet', :format => 'css'
  match '*path' => 'pages#show'
end
