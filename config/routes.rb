Rails.application.routes.draw do
  root to: 'vehicles#index'

  post 'import', to: 'vehicles#import', as: :import
  post 'search', to: 'vehicles#search', as: :search
  get 'report.csv', to: 'vehicles#report', as: :report
end
