class Notifier < ActionMailer::Base
  include ActionDispatch::Routing::UrlFor
  include ActionController::PolymorphicRoutes
  include Rails.application.routes.url_helpers
  default_url_options[:host] = 'example.com'
  default from: "no-reply@example.com"
  
  def welcome(user)
    @account = user
    mail(:to = user.email)
  end

  def notify(user, posting)
    @account = user
    @posting = posting
    @siteurl = url_for(action: index)
    @postingurl = url_for(posting)
    mail(:to = user.email)
  end

end
