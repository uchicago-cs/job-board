class Notifier < ActionMailer::Base
  default :from => "no-reply@cs.uchicago.edu"
  layout 'mailer'

  def employer_account_approved(employer)
    @to = employer.email
    @subject = "Your UChicago CS Jobs Board account has been approved!"
    @employer = employer
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'employer_account_approved' }
      format.html { render 'employer_account_approved' }
    end
  end

  def employer_posting_status_change(posting)
    @employer = posting.employer
    @posting = posting

    unless @employer.digests
      @to = @employer.email
      to_mail = true

      if @posting.approved? && @employer.alert_on_approve
        @subject = "UChicago CS Jobs Board: Your post has been approved"
      elsif @posting.rejected? && @employer.alert_on_reject
        @subject = "UChicago CS Jobs Board: Your post has been rejected"
      elsif @posting.changes_needed? && @employer.alert_on_changes_needed
        @subject = "UChicago CS Jobs Board: Changes requested to your post"
      else
        to_mail = false
      end

      if to_mail
        mail(:to => @to, :subject => @subject) do |format|
          format.text { render 'employer_posting_status_change' }
          format.html { render 'employer_posting_status_change' }
        end
      end
    end
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
    Student.admins.each do |admin|
      @admin = admin
      if admin.alert_on_new_posting && !admin.digests
        @to = admin.email
        @subject = "UChicago CS Jobs Board: New Job Posting Notification"
        @posting = posting
        mail(:to => @to, :subject => @subject) do |format|
          format.text { render 'new_posting_notification' }
          format.html { render 'new_posting_notification' }
        end
      end
    end
  end

  def admin_updated_posting_notification(posting)
    Student.admins.each do |admin|
      if (admin.alert_on_updated_posting || (posting.reviewer == admin && admin.alert_on_my_updated_posting)) && !admin.digests
        @admin = admin
        @posting = posting
        @to = admin.email
        @subject = "UChicago CS Jobs Board: Updated Posting Notification"
        mail(:to => @to, :subject => @subject) do |format|
          format.text { render 'updated_posting_notification' }
          format.html { render 'updated_posting_notification' }
        end
      end
    end
  end

  def admin_alert_digest()

  end

  def student_job_alert(student, posting)

  end

  def student_alert_digest()

  end
end
