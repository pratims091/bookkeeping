# frozen_string_literal: true

module ApiErrors
  class ApiV1Exception < StandardError
    attr_reader :error_code, :message, :responsecode, :http_status_code, :description
    def initialize(options = {})
      @error_code = ''
      @message = options[:message] || ''
      @title = options[:title] || ''
      @responsecode = ''
      @http_status_code = :bad_request
      @description = ''
    end
  end

  class InvalidPhoneNumber < ApiV1Exception
    def initialize
      @error_code = 1001
      @message = 'Invalid phone number'
      @responsecode = @error_code.to_s
      @http_status_code = :unauthorized
    end
  end

  class InvalidOtp < ApiV1Exception
    def initialize
      @error_code = 1002
      @message = 'Invalid OTP'
      @responsecode = @error_code.to_s
      @http_status_code = :unauthorized
    end
  end

  class InvalidAuthToken < ApiV1Exception
    def initialize
      @error_code = 1004
      @message = 'Invalid authorization token'
      @responsecode = @error_code.to_s
      @http_status_code = :unauthorized
    end
  end

  class IdempotentRequest < ApiV1Exception
    def initialize
      @error_code = 1005
      @message = 'Idempotent request'
      @responsecode = @error_code.to_s
      @http_status_code = :not_acceptable
    end
  end
end
