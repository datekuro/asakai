class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer  :user_id, null: false
      t.text     :todo, null: false
      t.text     :problem
      t.text     :shared_information
      t.string   :over_work
      t.string   :status
      t.date     :published_on

      t.timestamps
    end
  end
end
