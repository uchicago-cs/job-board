class JobPostingsController < ApplicationController

  def index
    @job_postings = JobPosting.all
    @internships = JobPosting.where("jobtype = 'Internship'", :include => :tags)
    @parttime = JobPosting.where("jobtype = 'Part Time'", :include => :tags)
    @fulltime = JobPosting.where("jobtype = 'Full Time'", :include => :tags)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @job_postings }
    end
  end

  def show
    @job_posting = JobPosting.find(params[:id], :include => :tags)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job_posting }
    end
  end

  def new
    @job_posting = JobPosting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_posting }
    end
  end

  def edit
    @job_posting = JobPosting.find(params[:id])
  end

  def create
    @job_posting = JobPosting.new(params[:job_posting])

    respond_to do |format|
      if @job_posting.save
        format.html { redirect_to @job_posting, notice: 'Job posting was successfully created.' }
        format.json { render json: @job_posting, status: :created, location: @job_posting }
      else
        format.html { render action: "new" }
        format.json { render json: @job_posting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @job_posting = JobPosting.find(params[:id])

    respond_to do |format|
      if @job_posting.update_attributes(params[:job_posting])
        format.html { redirect_to @job_posting, notice: 'Job posting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job_posting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_posting = JobPosting.find(params[:id])
    @job_posting.destroy

    respond_to do |format|
      format.html { redirect_to job_postings_url }
      format.json { head :no_content }
    end
  end
end
