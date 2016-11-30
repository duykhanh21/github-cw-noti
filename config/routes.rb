Rails.application.routes.draw do
  post 'payload' => 'payload#index', :defaults => { :format => 'json' }
end
