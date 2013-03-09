class EmployersController < ApplicationController
  before_filter :deobfuscate_id

  load_and_authorize_resource

  def index
    @sort_by = params[:sort].nil? ? "id" : params[:sort]
    @sort_by = "id" if not ["id", "lastname", "company", "email", "number_of_posts"].include? @sort_by
    @sort_order = params[:order].nil? ? "asc" : params[:order]
    @sort_order = "asc" if not ["asc", "desc"].include? @sort_order

    if @sort_by == "number_of_posts"
      @employers = Employer.find(:all, :include => :postings).sort_by{|e| e.postings.count * (@sort_order == "asc" ? -1 : 1)}
    else
      @employers = Employer.order("#{@sort_by} #{@sort_order}").all
    end
  end

  def show
    @employer = Employer.find(params[:id])
  end

  def new
  end

  def edit
    @employer = @employer_with_password = Employer.find(params[:id])
    if current_student && current_student.is_admin?
      render 'employers/edit_for_admin'
    else
      render 'employers/edit'
    end
  end

  def create
  end

  def update
    @employer = Employer.find(params[:id])
    
    if current_student && current_student.is_admin? && !@employer.approved
      if params[:reject]
        redirect_to employer_delete_path(@employer) and return
      end
      if params[:approve]
        @employer.approve_account
      end
    elsif current_employer || (current_student && current_student.is_admin? && @employer.approved)
      @employer.update_attributes(params[:employer])
    end

    if @employer.save
      flash[:notice] = "Employer profile updated."
      redirect_to postings_path
    else
      flash[:alert] = "An error occurred."
      @employer_with_password = @employer
      render :action => "edit"
    end
  end

  def update_password
    @employer_with_password = Employer.find(params[:id])
    if @employer_with_password.update_with_password(params[:employer])
      sign_in @employer_with_password, :bypass => true
      flash[:notice] = "Password successfully updated."
      redirect_to root_path
    else
      @employer = Employer.find(params[:id])
      render "edit"
    end
  end

  def destroy
    @employer = Employer.find(params[:id])
    @employer.destroy

    flash[:notice] = "Employer was successfully deleted."
    redirect_to postings_path
  end
end
