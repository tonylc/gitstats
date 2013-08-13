class CommitRatio < ActiveRecord::Base
  default_scope order('date ASC')

  belongs_to :author

  validate :author_id, :presence => true
  validate :date, :presence => true

  attr_accessible :date, :src_lines, :test_lines
end
