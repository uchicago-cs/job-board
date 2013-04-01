class PostingsController < ApplicationController
  before_filter :deobfuscate_id

  load_and_authorize_resource

  def index
    @view = params[:view]

    # Validate the "view" mode
    # "all" => admins only
    # "owned" => employers only
    # "interests" => students only
    # "active" => all
    if (@view == "all" && (!current_student || !current_student.is_admin?)) ||
       (@view == "owned" && !current_employer) ||
       (@view == "interests" && (!current_student || current_student.is_admin?)) ||
       (!["all", "owned", "interests", "active"].include?(@view))
      if current_employer
        @view = "owned"
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
        @entrepreneurial = Posting.all_entrepreneurial.where("? >= ?", :active_until, DateTime.now)
      when "active"
        @internships = Posting.all_approved_internships.where("? >= ?", :active_until, DateTime.now)
        @parttime = Posting.all_approved_parttime.where("? >= ?", :active_until, DateTime.now)
        @fulltime = Posting.all_approved_fulltime.where("? >= ?", :active_until, DateTime.now)
        @entrepreneurial = Posting.all_approved_entrepreneurial.where("? >= ?", :active_until, DateTime.now)
      when "owned"
        @internships = current_employer.internship_postings.where("? >= ?", :active_until, DateTime.now)
        @parttime = current_employer.parttime_postings.where("? >= ?", :active_until, DateTime.now)
        @fulltime = current_employer.fulltime_postings.where("? >= ?", :active_until, DateTime.now)
        @entrepreneurial = current_employer.entrepreneurial_postings.where("? >= ?", :active_until, DateTime.now)
      when "interests"
        @internships = Posting.all_approved_internships.where("? >= ?", :active_until, DateTime.now) if current_student.interested_in_internships?
        @parttime = Posting.all_approved_parttime.where("? >= ?", :active_until, DateTime.now) if current_student.interested_in_part_time?
        @fulltime = Posting.all_approved_fulltime.where("? >= ?", :active_until, DateTime.now) if current_student.interested_in_full_time?
        @entrepreneurial = Posting.all_approved_entrepreneurial.where("? >= ?", :active_until, DateTime.now) if current_student.interested_in_entrepreneurial?
    end

    if current_student && current_student.is_admin?
      @accounts_pending_approval = Employer.accounts_pending_approval
      @postings_pending_approval = Posting.postings_pending_approval
    elsif current_employer
      @postings_rejected = Posting.where(:employer_id => current_employer, :state => 0)
      @postings_needing_revision = Posting.where(:employer_id => current_employer, :state => 2)
    end
  end

  def show
    @posting = Posting.find(params[:id], :include => :tags)
  end

  def new
    @posting = Posting.new
    @posting.contact = current_employer.email
    @posting.company = current_employer.company
    @posting.active_until = Date.today + 1.month
    @current_tags = []
    @tags = Tag.all
  end

  def edit
    @posting = Posting.find(params[:id])
    @tags = Tag.all
  end

  def create
    @posting = Posting.new
    @posting.title = params[:posting][:title]
    @posting.description = params[:posting][:description]
    @posting.jobtype = params[:posting][:jobtype]
    @posting.contact = params[:posting][:contact]
    @posting.active_until = Date.new(params[:posting]["active_until(1i)"].to_i, params[:posting]["active_until(2i)"].to_i, params[:posting]["active_until(3i)"].to_i)
    @posting.company = params[:posting][:company]
    @posting.url = params[:posting][:url]
    @posting.location = params[:posting][:location]
    @posting.attachment = params[:posting][:attachment]
    @posting.employer = current_employer
    @posting.rich_description = (params[:posting][:rich_description] == "t")
    if not @posting.save
      @current_tags = Posting.parse_tags(params[:posting][:tags])
      @tags = Tag.all
      render :action => :new
      return
    end

    @posting.tags = params[:posting][:tags]
    @posting.state = :pending

    @posting.save!

    flash[:notice] = "Your job posting has been submitted and is pending approval. You will be notified via e-mail once it has been reviewed by an administrator."
    redirect_to @posting
  end

  def update
    @posting = Posting.find(params[:id])

    if current_employer || (current_student && current_student.is_admin? && params[:edit])
      @posting.assign_attributes(params[:posting].except(:tags, :rich_description))
      @posting.rich_description = (params[:posting][:rich_description] == "t")
      @posting.comments = nil
      @posting.state = :pending if current_employer
      @posting.tags.clear
      @posting.tags = params[:posting][:tags]
      if current_employer
        flash[:notice] = "Your job posting has been updated. Your changes will have to be approved by an administrator before the updated posting is published."
      elsif current_student && current_student.is_admin?
        flash[:notice] = "The job posting has been updated."
      end
      next_page = @posting
    elsif current_student && current_student.is_admin?
      @posting.comments = params[:posting][:comments]
      @posting.reviewer = current_student
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
      next_page = postings_path
    end

    @posting.save

    redirect_to next_page
  end

  def destroy
    @posting = Posting.find(params[:id])
    @posting.destroy

    redirect_to postings_path
  end
end
