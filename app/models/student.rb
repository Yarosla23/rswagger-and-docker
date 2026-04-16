class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class, counter_cache: true

  validates :first_name, :last_name, :surname, presence: true, length: {minimum: 2, maximum: 50}

  validate :school_class_belongs_to_same_school

  def auth_token
    self.class.build_auth_token(id)
  end

  alias_method :generate_token, :auth_token

  def valid_auth_token?(token)
    expected_token = auth_token
    provided_token = token.to_s

    return false if provided_token.blank? || expected_token.bytesize != provided_token.bytesize

    ActiveSupport::SecurityUtils.secure_compare(expected_token, provided_token)
  end

  def self.build_auth_token(student_id)
    Digest::SHA256.hexdigest("#{student_id}#{auth_token_salt}")
  end

  def self.auth_token_salt
    ENV["AUTH_TOKEN_SALT"].presence || Rails.application.credentials.secret_key_base
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
