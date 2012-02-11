class JobPostingsController < ApplicationController
    def index
        @job_postings = JobPosting.all
    end
end
