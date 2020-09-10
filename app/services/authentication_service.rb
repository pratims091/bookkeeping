# frozen_string_literal: true

class AuthenticationService
  def self.generate_authentication_token(user)
    payload = {
      user_id: user.id,
      phone_number: user.phone_number
    }
    JsonWebToken.encode payload
  end

  def self.verify_token(token)
    decoded = JsonWebToken.decode(token)
    raise ApiErrors::InvalidAuthToken if decoded.nil?

    user = User.find(decoded[:user_id])

    user
  end
end
