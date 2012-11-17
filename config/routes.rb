Smithy::Engine.routes.draw do
  root :to => 'pages#root'
  scope "/smithy" do
    # CMS admin
    resources :assets
    resources :content_blocks
    resources :pages do
      resources :contents, :controller => "PageContents", :except => [ :index ] do
        member do
          get :preview
        end
      end
    end
    resources :templates
    resources :settings

    # Content Blocks
    resources :contents, :except => :index
    resources :images, :except => :index
  end
  match '*path' => 'pages#show'
end
