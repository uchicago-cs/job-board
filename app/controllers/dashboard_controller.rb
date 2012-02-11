class DashboardController < ApplicationController

    before_filter :authenticate_user!

  def index
    @pending_postings = JobPosting.where(:state=>"Pending Approval")
    @active_postings = JobPosting.where(:state=>"Approved")

    # TODO: Filter inactive postings

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
