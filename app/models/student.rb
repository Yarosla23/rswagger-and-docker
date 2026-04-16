class Student < ApplicationRecord
  NAME_LENGTH_RANGE = 2..50

  belongs_to :school, inverse_of: :students
  belongs_to :school_class, inverse_of: :students

  validates :first_name, :last_name, :surname, presence: true, length: { in: NAME_LENGTH_RANGE }

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
    Rails.application.credentials.secret_key_base
  end
end
