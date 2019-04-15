class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :code, null: false
      t.references :reactionable, polymorphic: true
      t.timestamps
    end
  end
end
