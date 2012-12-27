class Tag < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :students
  has_and_belongs_to_many :postings

  def find_or_create_by_name tagname
    if not tagname.empty?
      tag = Tag.find_by_name(tagname)
      if tag.nil?
        tag = Tag.new
        tag.name = tagname
        tag.save!
      end
      return tag
    end
  end
end
