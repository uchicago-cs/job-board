class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :trackable, :ldap_authenticatable, :authentication_keys => [:cnet]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :cnet, :firstname, :lastname, :role
  has_and_belongs_to_many :tags

  before_create :get_ldap_info

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
end
