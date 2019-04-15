require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:comment) { build(:comment, user: user) }
  let(:article) { create(:article, :with_user) }
  let(:article_comment) { create(:article_comment, article: article, comment: comment) }

  it { should belong_to(:user) }
  it { should have_many(:article_comments) }
  it { should have_many(:articles).through(:article_comments) }
  it { should have_many(:reactions) }

  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:user_id) }
  it { should_not accept_values_for(:user_id, nil, "", "abcd") }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(65535) }
  it { should_not accept_values_for(:body, nil, "") }

  describe :scope do
    context :latest do
      let!(:comment) { create(:comment, :with_user) }
      let!(:comment2) { create(:comment, user: user, created_at: 1.day.ago, updated_at: 1.day.ago) }

      it do
        expect(Comment.latest).to eq [comment, comment2]
      end
    end
  end

  describe :instance_method do
    context :is_mine? do
      let(:user2) { create(:user) }
      it 'is true' do
        expect(comment.is_mine?(user)).to be true
      end

      it 'is false' do
        expect(comment.is_mine?(user2)).to be false
      end

      it 'is false' do
        expect(comment.is_mine?(nil)).to be false
      end
    end
  end
end
