require "rails_helper"

RSpec.describe SchoolClass, type: :model do
  subject(:school_class) { create(:school_class, school:, letter: "А", number: 5) }

  let(:school) { create(:school) }

  it { is_expected.to belong_to(:school) }
  it { is_expected.to have_many(:students).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_numericality_of(:number).only_integer.is_greater_than(0).is_less_than(12) }

  it { is_expected.to validate_presence_of(:letter) }
  it { is_expected.to validate_length_of(:letter).is_at_most(1) }
  it { is_expected.to allow_value("А").for(:letter) }
  it { is_expected.not_to allow_value("AB", "a", "1").for(:letter) }

  it { is_expected.to validate_numericality_of(:students_count).only_integer.is_greater_than_or_equal_to(0) }

  describe "dependent destroy" do
    let!(:student) { create(:student, school:, school_class:) }

    it "destroys students with the class" do
      expect { school_class.destroy }.to change(Student, :count).by(-1)
      expect(Student.find_by(id: student.id)).to be_nil
    end
  end
end
