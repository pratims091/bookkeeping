# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      def create
        param! :user, Hash, required: true do |u|
          u.param! :name, String, required: false
          u.param! :phone_number, String, required: true
        end
        param! :otp, Integer, required: true

        raise ApiErrors::InvalidOtp if params[:otp] != 1234 # Do an actual OTP erification

        user = User.new user_params

        if user.valid?
          user.save!

          token = AuthenticationService.generate_authentication_token user

          render json: { user: serialize(user), token: token }, status: :created
        else
          render json: { error: { message: user.errors.full_messages.join(',') } }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :phone_number)
      end
    end
  end
end
