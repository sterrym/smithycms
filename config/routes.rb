Smithy::Engine.routes.draw do
  root :to => 'pages#root'
  scope "/smithy" do
    # CMS admin
    resources :content_blocks
    resources :pages do
      resources :contents, :controller => "PageContents", :only => [ :new, :create, :edit, :update, :destroy ] do
        member do
          get :preview
        end
      end
    end
    resources :templates
    resources :settings

    # Content Blocks
    resources :contents, :except => :index
  end
  match '*path' => 'pages#show'
end
