class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    can :read, JobPosting

    if user.type == "Administrator"
	can :manage, :all
    end

    if user.type == "JobSeeker"
	can :read, JobPosting
    end

    if user.type == "Employer"
	can :read, JobPosting
	can :update, JobPosting, :user_id => user.id
	can :create, JobPosting
    end

  end
end
