class DashboardController < ApplicationController

    before_filter :authenticate_user!

  def index
    if current_user.type == "Administrator"
      @pending_postings = JobPosting.where(:state=>"Pending Approval")
      @active_postings = JobPosting.where(:state=>"Approved")
    elsif current_user.type == "JobSeeker"
      nil
    elsif current_user.type == "Employer"
      @employer_postings = JobPosting.where(:employer_id=>current_user)
    end

    # TODO: Filter inactive postings

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
