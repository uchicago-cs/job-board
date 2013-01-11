class StudentsController < ApplicationController
  before_filter :deobfuscate_id

  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
    @student = Student.find(params[:id])
    
    if @student.is_admin?
      render :template => "students/edit_admin"
    else
      render :template => "students/edit"
    end
  end

  def create
  end

  def update
    @student = Student.find(params[:id])

    @student.update_attributes(params[:student])

    if @student.save
      flash[:notice] = "Profile updated."
      redirect_to postings_path
    else
      flash[:alert] = "An error occurred."
      if @student.is_admin?
        render :template => "students/edit_admin"
      else
        render :template => "students/edit"
      end
    end
  end

  def destroy
  end
end
