Smithy::Engine.routes.draw do
  root :to => 'pages#show'
  scope "/smithy" do
    match '/' => redirect('/smithy/pages')
    match '/login'  => redirect('/'), :as => :login
    match '/logout' => redirect('/'), :as => :logout, :via => :delete
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

    # Content Pieces
    # scope "/content_pieces" do
    #   # ie. /smithy/content_pieces/locations/1/edit
    # end
  end
  # Sitemap
  resource :sitemap, :controller => "Sitemap", :only => [ :show ]
  match '/templates/javascripts/*javascript' => 'templates#javascript', :defaults => { :format => 'js' }
  match '/templates/stylesheets/*stylesheet' => 'templates#stylesheet', :format => 'css'
  match '*path' => 'pages#show'
end
