class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :gender)
  end
  def after_sign_up_path_for(user)
    edit_profile_path(user)
  end
  def after_sign_in_path_for(resource)
   home_index_path
  end
end