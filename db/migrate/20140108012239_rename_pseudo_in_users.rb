class RenamePseudoInUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :pseudo, :username
  end
end
