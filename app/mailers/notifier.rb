class Notifier < ActionMailer::Base
  default :from => "jobboard-notifications@cs.uchicago.edu"
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

  def admin_new_employer_notification(employer, admin)
    @admin = admin
    @to = admin.email
    @subject = "UChicago CS Jobs Board: New Employer Notification"
    @employer = employer
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'new_employer_notification' }
      format.html { render 'new_employer_notification' }
    end
  end

  def admin_new_posting_notification(posting, admin)
    @admin = admin
    @to = admin.email
    @subject = "UChicago CS Jobs Board: New Job Posting Notification"
    @posting = posting
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'new_posting_notification' }
      format.html { render 'new_posting_notification' }
    end
  end

  def admin_updated_posting_notification(posting, admin)
    @admin = admin
    @posting = posting
    @to = admin.email
    @subject = "UChicago CS Jobs Board: Updated Posting Notification"
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'updated_posting_notification' }
      format.html { render 'updated_posting_notification' }
    end
  end

  def admin_alert_digest(admin, new_postings, new_employers, updated_postings)
    @admin = admin
    @new_postings = new_postings
    @new_employers = new_employers
    @updated_postings = updated_postings
    @to = admin.email
    @subject = "UChicago CS Jobs Board Daily Summary"
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'admin_alert_digest' }
      format.html { render 'admin_alert_digest' }
    end
  end

  def student_job_alert(posting, student)
    @student = student
    @posting = posting
    @to = student.email
    @subject = "New position on the UChicago CS Jobs Board: #{@posting.title} at #{@posting.company}"
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'student_job_alert' }
      format.html { render 'student_job_alert' }
    end
  end

  def student_alert_digest(student, postings)
    @student = student
    @postings = postings
    @to = student.email
    @subject = "UChicago CS Jobs Board Weekly Summary: #{postings.count} #{postings.count == 1 ? "Position" : "Positions"} of Interest"
    mail(:to => @to, :subject => @subject) do |format|
      format.text { render 'student_alert_digest' }
      format.html { render 'student_alert_digest' }
    end
  end

end
