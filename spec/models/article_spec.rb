require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:today) { Time.zone.now }
  let(:article) { build(:article, published_on: today) }
  let(:user) { create(:user) }

  it { should belong_to(:user) }
  it { should have_many(:article_comments).dependent(:delete_all) }
  it { should have_many(:comments) }
  it { should have_many(:reactions) }

  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:user_id) }
  it { should_not accept_values_for(:user_id, nil, "", "abcd") }

  it { should validate_presence_of(:todo) }
  it { should validate_length_of(:todo).is_at_most(65535) }
  it { should_not accept_values_for(:todo, nil, "") }

  it { should validate_presence_of(:published_on) }
  it { should allow_value('2020-01-01').for(:published_on) }
  it { should_not accept_values_for(:published_on, nil, "", "abcd") }

  describe :validate do
    before do
      article.user_id = user.id
    end

    subject { article.valid? }

    context :published_on do
      context :valid do
        it { is_expected.to be true }
      end

      context :invalid do
        context :deplicated do
          let!(:article2) { create(:article, user_id: user.id, published_on: today) }
          it do
            is_expected.to be false
            expect(article.errors.keys).to include(:published_on)
          end
        end
      end
    end
  end

  describe :scope do
    let!(:article) { create(:article, :with_user, published_on: today) }
    let!(:article2) { create(:article, :with_user, user_id: user.id, published_on: today) }

    context :by_user do
      it 'ArgumentError' do
        expect { Article.by_user }.to raise_error(ArgumentError)
      end

      it 'is nil' do
        expect(Article.by_user(nil)).to eq []
      end

      it 'is empty' do
        expect(Article.by_user('')).to eq []
      end

      it do
        expect(Article.all.size).to eq 2
        expect(Article.by_user(user)).to include article2
      end
    end

    context :current_published_on do
      let(:yesterday) { today - 1.day }
      let!(:yesterday_article) { create(:article, :with_user, published_on: yesterday) }

      it 'is nil' do
        expect(Article.current_published_on(nil)).to eq []
      end

      it 'is empty' do
        expect(Article.current_published_on('')).to eq []
      end

      it 'is today' do
        expect(Article.current_published_on.size).to eq 2
        expect(Article.current_published_on).to include(article, article2)
      end

      it 'is yesterday' do
        expect(Article.current_published_on(yesterday).size).to eq 1
        expect(Article.current_published_on(yesterday)).to include(yesterday_article)
      end
    end

    context :draft do
      let(:published_article) { create(:article, :with_user, status: 'publish') }

      it do
        expect(Article.draft).to eq [article, article2]
      end
    end

    context :published do
      let(:published_article) { create(:article, :with_user, status: 'publish') }

      it do
        expect(Article.published).to eq [published_article]
      end
    end

    context :include_draft_is_mine do
      it do
        expect(Article.include_draft_is_mine(user)).to eq [article2]
      end
    end
  end

  describe :status do
    let(:published_article) { build(:article, status: 'publish') }

    it 'draft -> publish' do
      article.published
      expect(article.publish?).to be true
    end

    it 'publish -> draft' do
      published_article.withdrew
      expect(published_article.publish?).not_to be true
    end
  end
end
