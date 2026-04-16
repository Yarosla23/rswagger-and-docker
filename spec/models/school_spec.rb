require "rails_helper"

RSpec.describe School, type: :model do
  subject(:school) { create(:school) }

  it { is_expected.to have_many(:school_classes).dependent(:destroy) }
  it { is_expected.to have_many(:students).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100) }
end
