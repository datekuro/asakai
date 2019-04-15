module BelongsToUserModule
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    validates :user_id, presence: true, numericality: { only_integer: true }

    scope :by_user, ->(user) { where(user_id: user) }

    def is_mine?(user)
      user_id == user.try(:id)
    end
  end
end