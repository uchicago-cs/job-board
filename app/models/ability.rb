class Ability
  include CanCan::Ability

  def initialize(user)
    if user.kind_of? Employer
      can :manage, Employer, :id => user.id
      can [:create, :update, :destroy], Posting, :employer_id => user.id
      can :read, Posting do |posting|
        posting.visible? || posting.employer_id == user.id
      end
    elsif user.kind_of?(Student) && user.is_admin?
      can :manage, Posting
      can :manage, Student
      can :manage, Employer
    elsif user.kind_of? Student
      can :manage, Student, :id => user.id
      can :read, Posting do |posting|
        posting.visible?
      end
    else
      can :read, Posting do |posting|
        posting.visible?
      end
    end
  end
end
