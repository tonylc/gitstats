class CreateCommitDate < ActiveRecord::Migration
  def change
    create_table :commit_dates do |t|
      t.integer :author_id, :null => false
      t.datetime :date, :null => false
      t.text :data
    end
  end
end
