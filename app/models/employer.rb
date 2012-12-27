class Employer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:email]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :firstname, :lastname, :url, :company, :note_to_reviewer, :approved
  has_many :postings

  def self.accounts_pending_approval?
    Employer.where(:approved => false).count > 0
  end

  def self.accounts_pending_approval
    Employer.where(:approved => false)
  end
end
