class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class

  validates :first_name, :last_name, :surname, presence: true

  def generate_token
    Digest::SHA256.hexdigest("#{id}#{Rails.application.credentials.secret_key_base}")
  end
end
