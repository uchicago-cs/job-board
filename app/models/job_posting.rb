class JobPosting < ActiveRecord::Base
  belongs_to :employer
  has_and_belongs_to_many :tags

#  after_create :new_posting
#  after_save :modified


  private
  
  def new_posting
    #Broken
#    Administrator.each do |user|
#      Notifier.notify_administrator(user,self).deliver
#    end
    return true
  end

  def modified
    if state == "Approved"
      approved
    else if state == "Changes Needed"
           Notifier.posting_returned(employer,self).deliver
         else
           Notifier.posting_modified(employer,self).deliver
         end
    end
    return true
  end

  def approved
    Notifier.posting_approved(employer,self).deliver

    #This needs to be fixed
#    jseekers = JobSeeker.where(jobtype => true)
#    jseekers.each do |user|
#      Notifier.notify_jobseeker(user, self).deliver
#    end
  end


end
