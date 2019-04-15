require 'rails_helper'

RSpec.describe User, type: :model do
  let(:email) { 'user@example.com' }
  let(:user) { create(:user, email: email) }

  it { should have_many(:articles) }
  it { should have_many(:comments) }
  it { should have_many(:post_comment_articles).through(:comments).source(:articles) }
  it { should have_many(:received_comments).through(:articles).source(:comments) }

  describe :instance_method do
    context :display_name do

      subject { user.display_name }

      it 'is email' do
        user.nickname = ''
        expect(subject).not_to eq email
      end

      it 'is nickname' do
        user.nickname = 'piyohiko'
        expect(subject).not_to eq email
      end
    end
  end
end
