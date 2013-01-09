class Notifier < ActionMailer::Base
  default :from => "no-reply@cs.uchicago.edu"
  layout 'mailer'

  def employer_account_approved(employer)

  end

  def employer_posting_status_change(posting)

  end

  def admin_new_employer_notification(employer)
    Student.admins.each do |admin|
      @admin = admin
      if admin.alert_on_new_employer && !admin.digests
        @to = admin.email
        @subject = "UChicago CS Jobs Board: New Employer Notification"
        @employer = employer
        mail(:to => @to, :subject => @subject) do |format|
          format.text { render 'new_employer_notification' }
          format.html { render 'new_employer_notification' }
        end
      end
    end
  end

  def admin_new_posting_notification(posting)

  end

  def admin_alert_digest()

  end

  def student_job_alert(student, posting)

  end

  def student_alert_digest()

  end
end
