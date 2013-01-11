class ApplicationController < ActionController::Base
  require 'obfuscation' unless defined?(Obfuscation)

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

  def deobfuscate_id
    params[:id] = Obfuscation.deobfuscate(params[:id].to_i)
  end

end
