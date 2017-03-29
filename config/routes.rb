Rails.application.routes.draw do

  root                     "page#index"
  get "/share-note/:id" => "page#share_note",   as: "share_note"
  get "/tos"            => "page#tos",          as: "tos"

  resource :admin,    only: [:index] do
    get "/"             => "admins#index"
    get "/stat/:collection" => "admins#stat",   as: "stat"
  end

  resources :notes do
    collection do
      get "/tag/:tag"   => "notes#tag",         as: "tag"
    end
  end

  resources :users

  resource :account, controller: "account", only: [:new, :create] do
    get "/"             => "account#index"
    collection do

      {
        new:              ["get", "post"],
        login:            ["get", "post"],
        logout:           ["get"],
        forgot_password:  ["get", "post"],
        reset_password:   ["get", "post"],
        confirm_email:    ["get"],
        setting:          ["get", "post"]
      }.each do |path, http_methods|
        http_methods.each do |http_method|
          action_name, as_name = http_method == "get" ? [path, path.to_s] : ["#{path}_#{http_method}", nil]
          method(http_method).call("/#{path}" => ["account", action_name].join("#"), as: as_name)
        end
      end

    end
  end

end
