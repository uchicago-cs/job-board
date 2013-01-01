class PostingsController < ApplicationController
  def index
    @view = params[:view]

    # Validate the "view" mode
    if @view == "all" && (!current_student || !current_student.is_admin?)
      # Only admins can use "all"
      if current_employer
        @view = "owned"
      else
        @view = "active"
      end
    elsif @view == "owned" && !current_employer
      # "owned" is meaningless for anyone but employers
      if current_student && current_student.is_admin?
        @view = "all"
      else
        @view = "active"
      end
    elsif @view != "active"
      # Anything else other than "active" is invalid (or set defaults if nil)
      if current_employer
        @view = "owned"
      elsif current_student && current_student.is_admin?
        @view = "all"
      else
        @view = "active"
      end
    end

    # Get the appropriate postings for the given view
    case @view
      when "all"
        @internships = Posting.all_internships.where("? >= ?", :active_until, DateTime.now)
        @parttime = Posting.all_parttime.where("? >= ?", :active_until, DateTime.now)
        @fulltime = Posting.all_fulltime.where("? >= ?", :active_until, DateTime.now)
      when "active"
        @internships = Posting.all_approved_internships.where("? >= ?", :active_until, DateTime.now)
        @parttime = Posting.all_approved_parttime.where("? >= ?", :active_until, DateTime.now)
        @fulltime = Posting.all_approved_fulltime.where("? >= ?", :active_until, DateTime.now)
      when "owned"
        @internships = current_employer.internship_postings.where("? >= ?", :active_until, DateTime.now)
        @parttime = current_employer.parttime_postings.where("? >= ?", :active_until, DateTime.now)
        @fulltime = current_employer.fulltime_postings.where("? >= ?", :active_until, DateTime.now)
    end

    if current_student && current_student.is_admin?
      @accounts_pending_approval = Employer.accounts_pending_approval
      @postings_pending_approval = Posting.postings_pending_approval
    end
  end

  def show
    @posting = Posting.find(params[:id], :include => :tags)
  end

  def new
    @posting = Posting.new
    @posting.contact = current_employer.email
    @posting.company = current_employer.company
    @tags = Tag.all
  end

  def edit
    @posting = Posting.find(params[:id])
    @tags = Tag.all
  end

  def create
    @posting = Posting.create
    @posting.title = params[:posting][:title]
    @posting.description = params[:posting][:description]
    @posting.jobtype = params[:posting][:jobtype]
    @posting.contact = params[:posting][:contact]
    @posting.active_until = Date.new(params[:posting]["active_until(1i)"].to_i, params[:posting]["active_until(2i)"].to_i, params[:posting]["active_until(3i)"].to_i)
    @posting.company = params[:posting][:company]
    @posting.url = params[:posting][:url]
    @posting.employer = current_employer

    tags = params[:posting][:tags].split(";")
    tags.each do |tag|
      @posting.tags << Tag.find_or_create_by_name(tag)
    end

    @posting.state = :pending
    @posting.save!

    flash[:notice] = "Your job posting has been submitted and is pending approval. You will be notified via e-mail once it has been reviewed by an administrator."
    redirect_to @posting
  end

  def update
    @posting = Posting.find(params[:id])

    if current_employer
      @posting.state = :pending
      flash[:notice] = "Your job posting has been updated. Your changes will have to be approved by an administrator before the updated posting is published."
      next_page = @posting
    elsif current_student && current_student.is_admin?
      if params[:reject]
        @posting.state = :rejected
        flash[:notice] = "Job posting was rejected."
      elsif params[:request_changes]
        @posting.state = :changes_needed
        flash[:notice] = "Submitter has been notified that the job posting should be changed."
      elsif params[:approve]
        @posting.state = :approved
        flash[:notice] = "Job posting was approved."
      end
      @posting.comments = params[:posting][:comments]
      next_page = postings_path
    end

    @posting.save

    redirect_to next_page
  end

  def destroy
    @posting = Posting.find(params[:id])
    @posting.destroy

    redirect_to request.referer
  end
end
