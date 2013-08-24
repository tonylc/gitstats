class Author < ActiveRecord::Base
  has_many :commit_dates
  has_many :commit_ratios

  validate :name, :presence => true
  validate :email, :presence => true

  attr_accessible :name, :email

  def self.find_by_handle(handle)
    Author.where(Author.arel_table[:email].matches("%#{handle}@%")).first
  end
end