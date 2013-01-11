class ApplicationController < ActionController::Base
  require 'obfuscation' unless defined?(Obfuscation)

  protect_from_forgery

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_student || current_employer
      render :text => "Access denied.", :status => 403
    else
      session[:requested_path] = request.fullpath
      @student = Student.new
      @employer = Employer.new
      flash[:alert] = "You must log in to view this page"
      render "misc/combined_login"
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_student || current_employer)
  end

  def deobfuscate_id
    params[:id] = Obfuscation.deobfuscate(params[:id].to_i) if params[:id]
  end

  def after_sign_in_path_for(user)
    dest = nil
    if session[:requested_path]
      dest = session[:requested_path]
      session[:requested_path] = nil
    else
      dest = root_path
    end
    dest
  end

end
