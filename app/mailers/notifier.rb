class Notifier < ActionMailer::Base
  default :from => "no-reply@cs.uchicago.edu"

  def employer_account_approved(employer)

  end

  def employer_posting_status_change(posting)

  end

  def admin_new_employer_notification(employer)

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
