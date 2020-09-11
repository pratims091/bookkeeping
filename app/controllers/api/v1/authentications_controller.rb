# frozen_string_literal: true

module Api
  module V1
    class AuthenticationsController < Api::V1::ApiController
      def login
        param! :phone_number, String, required: true
        param! :otp, Integer, required: true

        raise ApiErrors::InvalidOtp if params[:otp] != 1234 # Do an actual OTP verification

        user = User.find_by(phone_number: params[:phone_number])

        raise ApiErrors::InvalidPhoneNumber if user.nil?

        token = AuthenticationService.generate_authentication_token user

        render json: { user: serialize(user), token: token }, status: :ok
      end
    end
  end
end
