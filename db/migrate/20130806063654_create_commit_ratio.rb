class CreateCommitRatio < ActiveRecord::Migration
  def change
    create_table :commit_ratios do |t|
      t.integer :author_id, :null => false
      t.datetime :date, :null => false
      t.integer :src_lines, :default => 0
      t.integer :test_lines, :default => 0
    end
  end
end
