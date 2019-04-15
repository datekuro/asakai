# == Schema Information
#
# Table name: articles
#
#  id                 :bigint(8)        not null, primary key
#  user_id            :integer          not null
#  todo               :text(65535)      not null
#  problem            :text(65535)
#  shared_information :text(65535)
#  over_work          :string(255)
#  status             :string(255)
#  published_on       :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Article < ApplicationRecord
  include BelongsToUserModule
  include AASM

  after_initialize do
    self.published_on ||= Time.zone.now
  end

  has_many :article_comments, dependent: :delete_all
  has_many :comments, through: :article_comments
  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :active_reactions, -> { Reaction.active }, as: :reactionable, class_name: 'Reaction', dependent: :destroy

  delegate :email, :display_name, to: :user, allow_nil: true

  with_options presence: true do
    validates :todo, length: { maximum: 65535 }
    validates :over_work, length: { maximum: 255 }
    validates :published_on, uniqueness: { scope: :user_id }
  end

  scope :current_published_on,  ->(date = Time.zone.now) { where(published_on: date) }
  scope :draft,  -> { where(status: 'draft') }
  scope :published,  -> { where(status: 'publish') }
  scope :include_draft_is_mine, ->(user) { by_user(user).draft }

  aasm column: :status do
    state :draft, initial: true
    state :publish

    event :published do
      transitions from: :draft, to: :publish
    end

    event :withdrew do
      transitions from: :publish, to: :draft
    end
  end

  def grouped_active_reactions
    active_reactions.select('reactions.id, reactions.code, count(reactions.code) as reaction_count').group(:code)
  end
end
