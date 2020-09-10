# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::Base
      protect_from_forgery with: :null_session

      before_action :before_actions

      rescue_from Exception do |e|
        error_code = 1000
        render_error(error_code, 'Oops! something went wrong, please try again in sometime',
                     :internal_server_error, "INTERNAL SERVER ERROR #{e.message}")
        raise if Rails.env.development? || Rails.env.test?
      end

      rescue_from ApiErrors::ApiV1Exception do |e|
        render_error(e.error_code, e.message, e.http_status_code.nil? ? :bad_request : e.http_status_code)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error_code = 1003
        render_error(error_code, 'The requested resource is not found', :not_found, e.message)
      end

      rescue_from RailsParam::Param::InvalidParameterError do |e|
        error_code = 1004
        render_error(error_code, e.message, :unprocessable_entity, e.message)
      end

      private

      def before_actions
        unless controller_name == 'authentications' || (controller_name == 'users' && action_name == 'create')
          validate_token
        end
        prevent_duplicate_request if controller_name == 'transactions' && action_name == 'create'
      end

      def validate_token
        token = request.headers['Authorization']

        @current_user = AuthenticationService.verify_token(token)
      end

      # Respond with error if the req is being made with same parameters in the span of 2 seconds
      def prevent_duplicate_request
        cache = Rails.cache
        key = params.to_s.hash
        duplcate_request = cache.exist?(key)
        cache.write(params.to_s.hash, true, expires_in: 2.seconds)
        raise ApiErrors::IdempotentRequest if duplcate_request
      end

      protected

      def render_error(error_code, custom_message, http_status_code, error_message = nil)
        Rails.logger.error("API V1 EXCEPTION ENV=#{Rails.env} CONTROLLER=#{controller_name}" \
                           " ACTION=#{action_name} ERROR_CODE=#{error_code} CUSTOM_MESSAGE=#{custom_message}" \
                           " ERROR_MESSAGE=#{error_message}" \
                           " PARAMS=#{request.filtered_parameters}")
        render json: { error: { code: error_code, message: custom_message } }, status: http_status_code
      end

      def serialize(resource)
        ActiveModelSerializers::SerializableResource.new(resource)
      end
    end
  end
end
