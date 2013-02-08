TechJobs::Application.routes.draw do

  devise_for :students, :controllers => { :sessions => "students/sessions" }

  devise_for :employers, :controllers => { :registrations => "employers/registrations",
                                           :sessions => "employers/sessions",
                                           :passwords => "employers/passwords" }

  match '/employers/:id/delete' => 'employers#destroy', :as => "employer_delete"
  match '/employers/:id/update_password' => 'employers#update_password', :as => "employer_update_password"
  match '/employers/instructions' => 'employers#instructions', :as => "employer_instructions"

  resources :postings
  resources :students
  resources :employers
  resources :admins

  root :to => "postings#index"

end
