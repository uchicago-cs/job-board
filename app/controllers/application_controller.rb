class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :text => "Access denied.", :status => 403
  end

  def current_ability
    @current_ability ||= Ability.new(current_student || current_employer)
  end

end
