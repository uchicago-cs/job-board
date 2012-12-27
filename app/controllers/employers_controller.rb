class EmployersController < ApplicationController
  def index
  end

  def show
    @employer = Employer.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    @employer = Employer.find(params[:id])
    
    if current_student && current_student.is_admin?
      if params[:approve]
        @employer.approve_account
      end
    end

    if @employer.save
      flash[:notice] = "Employer profile updated."
      redirect_to postings_path
    else
      flash[:alert] = "An error occurred."
      render :action => "edit"
    end
  end

  def destroy
  end
end
