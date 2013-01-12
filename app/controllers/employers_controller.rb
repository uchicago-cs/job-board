class EmployersController < ApplicationController
  before_filter :deobfuscate_id

  load_and_authorize_resource

  def index
  end

  def show
    @employer = Employer.find(params[:id])
  end

  def new
  end

  def edit
    @employer = @employer_password = Employer.find(params[:id])
  end

  def create
  end

  def update
    @employer = Employer.find(params[:id])
    
    if current_student && current_student.is_admin?
      if params[:reject]
        redirect_to employer_delete_path(@employer) and return
      end
      if params[:approve]
        @employer.approve_account
      end
    elsif current_employer
      @employer.update_attributes(params[:employer])
    end

    if @employer.save
      flash[:notice] = "Employer profile updated."
      redirect_to postings_path
    else
      flash[:alert] = "An error occurred."
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
