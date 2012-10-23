Smithy::Engine.routes.draw do
  scope "/smithy" do
    resources :pages
    resources :templates
    resources :settings
  end
end
