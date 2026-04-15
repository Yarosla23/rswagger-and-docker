class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class, counter_cache: true

  validates :first_name, :last_name, :surname, presence: true, length: { minimum: 2, maximum: 50 }

  validate :school_class_belongs_to_same_school

  def generate_token
    Digest::SHA256.hexdigest("#{id}#{Rails.application.credentials.secret_key_base}")
  end

  private

  def school_class_belongs_to_same_school
    if school_id.present? && school_class_id.present?
      unless school_class.school_id == school_id
        errors.add(:school_class_id, "должен принадлежать той же школе")
      end
    end
  end
end
