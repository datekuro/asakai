# == Schema Information
#
# Table name: article_comments
#
#  id         :bigint(8)        not null, primary key
#  article_id :bigint(8)
#  comment_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_article_comments_on_article_id  (article_id)
#  index_article_comments_on_comment_id  (comment_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (comment_id => comments.id)
#

class ArticleComment < ApplicationRecord
  belongs_to :article
  belongs_to :comment
end
