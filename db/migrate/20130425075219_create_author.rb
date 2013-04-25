class CreateAuthor < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, :null => false
      t.string :email, :null => false
    end
  end
end
