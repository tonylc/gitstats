class Author < ActiveRecord::Base
  has_many :commit_dates

  validate :name, :presence => true
  validate :email, :presence => true

  attr_accessible :name, :email
end