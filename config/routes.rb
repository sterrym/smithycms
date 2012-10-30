Smithy::Engine.routes.draw do
  scope "/smithy" do
    # CMS admin
    resources :content_blocks
    resources :pages do
      resources :contents, :controller => "PageContents",
        :only => [ :new, :create, :edit, :update, :destroy ]
    end
    resources :templates
    resources :settings

    # Content Blocks
    resources :contents, :except => :index
  end
  # match '*path', :to => 'pages#show'
end
