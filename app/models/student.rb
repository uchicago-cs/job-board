class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :trackable, :ldap_authenticatable, :authentication_keys => [:cnet]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :cnet, :firstname, :lastname, :role, :alert_on_new_employer, :alert_on_new_posting, :alert_on_updated_posting, :alert_on_my_updated_posting, :alert_on_new_recommendation, :digests, :email, :interested_in_internships, :interested_in_full_time, :interested_in_part_time
  has_and_belongs_to_many :tags
  has_many :postings, :foreign_key => 'reviewed_by'

  before_create :get_ldap_info
  after_create :init_student

  def get_ldap_info
    if Devise::LdapAdapter.get_ldap_param(self.cnet, "uid")
      self.email = Devise::LdapAdapter.get_ldap_param(self.cnet, "mail")
      self.firstname = Devise::LdapAdapter.get_ldap_param(self.cnet, "givenName")
      self.lastname = Devise::LdapAdapter.get_ldap_param(self.cnet, "sn")
      self.role = role_symbol_to_id(:user)
    end
  end

  def is_admin?
    role == role_symbol_to_id(:admin)
  end

  def make_admin
    self.role = role_symbol_to_id(:admin)
    init_admin
  end

  def remove_admin
    self.role = role_symbol_to_id(:user)
    init_student
  end

  def self.admins
    where(:role => 1)
  end

  def reviewed_pending_posts
    if self.is_admin?
      return self.postings.select {|p| p.state_as_string == "Pending"}
    else
      return []
    end
  end

  def interested_in_internships?
    interested_in_internships
  end

  def interested_in_part_time?
    interested_in_part_time
  end

  def interested_in_full_time?
    interested_in_full_time
  end

  def is_interested_in? posting
    return false if is_admin?
    case posting.job_type_as_symbol
      when :internship
        return interested_in_internships?
      when :parttime
        return interested_in_part_time?
      when :fulltime
        return interested_in_full_time?
    end
  end

  private

  def role_symbol_to_id(_role)
    case _role
      when :user then 0
      when :admin then 1
    end
  end

  def role_id_to_symbol(_role)
    case _role
      when 0 then :user
      when 1 then :admin
    end
  end

  def init_student
    self.alert_on_new_posting = false
    self.alert_on_new_recommendation = false
    self.digests = false
    self.save
  end

  def init_admin
    self.alert_on_new_employer = true
    self.alert_on_new_posting = true
    self.alert_on_updated_posting = true
    self.alert_on_my_updated_posting = true
    self.digests = false
    self.save
  end
end
