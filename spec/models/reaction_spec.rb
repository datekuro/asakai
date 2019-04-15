require 'rails_helper'

RSpec.describe Reaction, type: :model do
  let(:reaction) { build(:reaction) }
  let(:user) { create(:user) }

  it { should belong_to(:user) }
  it { should belong_to(:reactionable) }

  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:user_id) }
  it { should_not accept_values_for(:user_id, nil, "", "abcd") }

  it { should validate_presence_of(:code) }
  it { should_not accept_values_for(:code, nil, "") }
  it { should define_enum_for(:code).with_prefix.with_values(Reaction.codes) }

  it { should accept_values_for(:registered, true, false) }
  it { should_not accept_values_for(:registered, nil, "") }

  describe :validate do
    let(:article) { create(:article, :with_user) }

    before do
      reaction.user_id = user.id
      reaction.reactionable = article
    end

    subject { reaction.valid? }

    context :code do
      context :valid do
        it { is_expected.to be true }
      end

      context :invalid do
        let(:invalid_code) { reaction.code = 'dummy' }
        it do
          expect { invalid_code }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
