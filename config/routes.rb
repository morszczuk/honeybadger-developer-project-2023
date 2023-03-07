Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :report_spam_analysis, only: [:create]
    end
  end
end
