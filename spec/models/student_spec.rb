require "rails_helper"

RSpec.describe Student, type: :model do
  subject(:student) { build(:student) }

  it { is_expected.to belong_to(:school) }
  it { is_expected.to belong_to(:school_class) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:surname) }

  it { is_expected.to validate_length_of(:first_name).is_at_least(2).is_at_most(50) }
  it { is_expected.to validate_length_of(:last_name).is_at_least(2).is_at_most(50) }
  it { is_expected.to validate_length_of(:surname).is_at_least(2).is_at_most(50) }

  describe ".build_auth_token" do
    let(:student_id) { 42 }

    it "builds deterministic token for the same student id" do
      allow(described_class).to receive(:auth_token_salt).and_return("test-salt")

      expect(described_class.build_auth_token(student_id)).to eq(described_class.build_auth_token(student_id))
    end
  end
end
