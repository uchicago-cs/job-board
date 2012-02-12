class Notifier < ActionMailer::Base
#  include ActionDispatch::Routing::UrlFor
#  include ActionController::PolymorphicRoutes
#  include Rails.application.routes.url_helpers
#  default_url_options[:host] = 'example.com'
  default from: "no-reply@example.com"
  
  def welcome(user)
    @account = user
    mail(:to => user.email)
  end

  def set_vals(user, posting, message)
    @account = user
    @posting = posting
    @message = message
  end

  def notify_employer(user, posting, message)
    set_vals(user,posting, '')
    mail(:to => user.email)
  end

  def notify_jobseeker(user, posting)
    set_vals(user,posting, '')
    mail(:to => user.email)
  end

  def posting_approved(user, posting)
    notify_employer(user, posting, "approved")
  end

  def posting_modified(user, posting)
    notify_employer(user, posting, "modified")
  end

  def posting_returned(user, posting)
    notify_employer(user, posting, "returned")
  end

  def notify_administrator(user, posting)
    set_vals(user,posting, '')
    mail(:to => user.email)
  end

end
