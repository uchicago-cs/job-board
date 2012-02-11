class JobPosting < ActiveRecord::Base
  belongs_to :employer
  has_and_belongs_to_many :tags
end
