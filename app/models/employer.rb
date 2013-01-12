class Employer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:email]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :firstname, :lastname, :url, :company, :note_to_reviewer, :approved, :alert_on_approve, :alert_on_reject, :alert_on_changes_needed, :digests
  has_many :postings

  validates :firstname, :lastname, :company, :presence => true  # presence of :email is handled by devise
  validates :email, :uniqueness => true

  after_create :alert_admins_of_new_employer

  def to_param
    Obfuscation.obfuscate(self.id).to_s
  end

  def self.accounts_pending_approval?
    Employer.where(:approved => false).count > 0
  end

  def self.accounts_pending_approval
    Employer.where(:approved => false)
  end

  def internship_postings
    Posting.all_internships.where(:employer_id => self)
  end

  def parttime_postings
    Posting.all_parttime.where(:employer_id => self)
  end

  def fulltime_postings
    Posting.all_fulltime.where(:employer_id => self)
  end

  def approve_account
    self.approved = true
    save
    Notifier.employer_account_approved(self).deliver
  end

  private

  def alert_admins_of_new_employer
    Student.admins.each do |admin|
      if admin.alert_on_new_employer && !admin.digests
        Notifier.admin_new_employer_notification(self, admin).deliver
      end
    end
  end
end
