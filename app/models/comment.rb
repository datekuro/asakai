# == Schema Information
#
# Table name: comments
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  body       :text(65535)
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_deleted_at  (deleted_at)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Comment < ApplicationRecord
  include BelongsToUserModule

  acts_as_paranoid

  has_many :article_comments, dependent: :destroy
  has_many :articles, through: :article_comments
  has_many :reactions, as: :reactionable, inverse_of: :reactionable, dependent: :destroy
  has_many :active_reactions, -> { Reaction.active }, as: :reactionable, class_name: 'Reaction', dependent: :destroy

  delegate :display_name, to: :user, allow_nil: true

  validates :body, presence: true, length: { maximum: 65535 }

  scope :latest, -> { order(created_at: :desc) }

  def grouped_active_reactions
    active_reactions.select('reactions.id, reactions.code, count(reactions.code) as reaction_count').group(:code)
  end
end
