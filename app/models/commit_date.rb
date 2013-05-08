class CommitDate < ActiveRecord::Base
  belongs_to :author

  validate :author_id, :presence => true
  validate :date, :presence => true
  validate :data, :presence => true

  attr_accessible :date, :data

  def as_json(options={})
    [date, JSON.parse(data)]
  end
end
