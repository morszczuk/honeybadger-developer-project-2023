Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :report_spam_analysis, only: [:create]
    end
  end

  namespace :slack do
    resource :authorization, only: [:show]
    resource :access_token, only: [:show]
    resource :message, only: [:create]
  end
end
