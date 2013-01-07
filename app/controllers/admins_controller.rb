class AdminsController < ApplicationController
  def create
    @user = Student.find_by_cnet(params[:cnet])

    if @user.nil?
      flash[:alert] = "No user with that CNet ID exists."
    else
      if @user.make_admin
        flash[:notice] = "#{@user.firstname} #{@user.lastname} has been made an administrator."
      else
        flash[:alert] = "An error occurred."
      end
    end

    redirect_to edit_student_path(current_student)
  end

  def destroy
    @user = Student.find(params[:id])

    if @user.remove_admin
      flash[:notice] = "#{@user.firstname} #{@user.lastname} is no longer an administrator."
    else
      flash[:alert] = "An error occurred."
    end

    redirect_to edit_student_path(current_student)
  end
end
