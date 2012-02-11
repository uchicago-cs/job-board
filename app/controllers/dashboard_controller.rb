class DashboardController < ApplicationController

    before_filter :authenticate_user!

  def index
    @job_postings = JobPosting.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
