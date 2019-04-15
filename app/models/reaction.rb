# == Schema Information
#
# Table name: reactions
#
#  id                :bigint(8)        not null, primary key
#  user_id           :bigint(8)        not null
#  code              :integer          not null
#  registered        :boolean          default(FALSE), not null
#  reactionable_type :string(255)
#  reactionable_id   :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_reactions_on_reactionable_type_and_reactionable_id  (reactionable_type,reactionable_id)
#  index_reactions_on_user_id                                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Reaction < ApplicationRecord
  include BelongsToUserModule

  enum code: {
    thumbs_up: 0,
    thumbs_down: 1,
    heart: 2,
    exclamation: 3,
    question: 4,
    interrobang: 5
  }, _prefix: true

  belongs_to :reactionable, polymorphic: true

  validates :code, presence: true, inclusion: { in: Reaction.codes.keys }
  validates :registered, inclusion: {in: [true, false]}

  scope :active, -> { where(registered: true) }
end
