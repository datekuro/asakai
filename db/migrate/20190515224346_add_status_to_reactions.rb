class AddStatusToReactions < ActiveRecord::Migration[5.2]
  def change
    add_column :reactions, :registered, :boolean, null: false, default: false, after: :code
  end
end
