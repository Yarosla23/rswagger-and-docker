module BearerTokenAuthenticatable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private

  def bearer_token
    authenticate_with_http_token do |token, _options|
      token
    end
  end
end
