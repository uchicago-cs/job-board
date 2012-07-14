class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :cnet, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :type, :Full_Time, :Part_Time, :Internship
  has_and_belongs_to_many :tags

  before_save :get_ldap_info


  def get_ldap_info
    self.email = Devise::LdapAdapter.get_ldap_param(self.cnet, "mail")
    self.firstname = Devise::LdapAdapter.get_ldap_param(self.cnet, "givenName")
    self.lastname = Devise::LdapAdapter.get_ldap_param(self.cnet, "sn")
  end

  #validate :is_in_ldap

  #def is_in_ldap
  #  unless Devise::LdapAdapter.get_ldap_param(self.email, "uid")
  #    errors.add(:username, "is not a valid CNetID")
  #  end
  #end

end
