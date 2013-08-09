class Author < ActiveRecord::Base
  has_many :commit_dates
  has_many :commit_ratios

  validate :name, :presence => true
  validate :email, :presence => true

  attr_accessible :name, :email
end