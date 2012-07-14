class JobPostingsController < ApplicationController

  def index
    @job_postings = JobPosting.all
    @internships = JobPosting.where({:state => 'Approved', :jobtype => 'Internship'}, :include => :tags)
    @parttime = JobPosting.where({:state => 'Approved', :jobtype => 'Part Time'}, :include => :tags)
    @fulltime = JobPosting.where({:state => 'Approved', :jobtype => 'Full Time'}, :include => :tags)

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
    @alltags = Tag.all
    
    @job_posting.affiliation = params[:affiliation]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_posting }
    end
  end

  def edit
    @job_posting = JobPosting.find(params[:id])
  end

  def create
    @job_posting = JobPosting.create
    @job_posting.title = params[:job_posting][:title]
    @job_posting.description = params[:job_posting][:description]
    @job_posting.jobtype = params[:job_posting][:jobtype]
    @job_posting.contact = params[:job_posting][:contact]
    @job_posting.deadline = Date.new(params[:job_posting]["deadline(1i)"].to_i, params[:job_posting]["deadline(2i)"].to_i, params[:job_posting]["deadline(3i)"].to_i)
	@job_posting.affiliation = params[:affiliation]

	tags = params[:job_posting][:tags].split(";")
	tags.each do |t|
      if t != ""
        oldtag = Tag.where("name = ?", t).first
        if oldtag.nil?
          newtag = Tag.create
          newtag.name = t
          newtag.save!
          @job_posting.tags << newtag
        else
          @job_posting.tags << oldtag
        end
      end
    end

    if current_user.type == "Employer"
       @job_posting.employer_id = current_user.id
       @job_posting.state = "Pending Approval"
       notice = "Your job posting has been submitted and is pending approval. You will be notified via e-mail once it has been reviewed by an administrator."
       next_page = @job_posting
    elsif current_user.type == "Administrator" 
       @job_posting.state = "Approved"
       notice = "Job posting was successfully created."
       next_page = @job_posting
    end

    respond_to do |format|
      if @job_posting.save
        format.html { redirect_to next_page, notice: notice }
        format.json { render json: @job_posting, status: :created, location: @job_posting }
      else
        format.html { render action: "new" }
        format.json { render json: @job_posting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @job_posting = JobPosting.find(params[:id])


    if current_user.type == "Employer"
       params[:job_posting][:state] = "Pending Approval"
       notice = "Your job posting has been updated. Your changes will have to be approved by an administrator before the updated posting is published."
        next_page = @job_posting
    elsif current_user.type == "Administrator" 
      if params[:reject]
        params[:job_posting][:state] = "Rejected"
        notice = 'Job posting was rejected.'
        next_page = dashboard_path
      elsif params[:request_changes]
        params[:job_posting][:state] = "Changes needed"
        notice = 'Submitter has been notified that the job posting should be changed.'
        next_page = dashboard_path
      elsif params[:approve]
        params[:job_posting][:state] = "Approved"
        notice = 'Job posting was approved.'
        next_page = dashboard_path
      else     
        notice = 'Job posting was successfully updated.'
        next_page = @job_posting
      end
    end

    respond_to do |format|
      if @job_posting.update_attributes(params[:job_posting])
        format.html { redirect_to next_page, notice: notice }
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
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end
end
