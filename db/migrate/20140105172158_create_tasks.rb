class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :status

      t.timestamps
    end

    create_table :api_keys do |t|
    	t.string :access_token

    	t.timestamps
    end
  end
end
