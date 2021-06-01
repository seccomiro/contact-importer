module Devise
  module Strategies
    class Jwt < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        token = request.headers.fetch('Authorization', '').last
        success! User.from_token(token)
      rescue ::JWT::ExpiredSignature
        fail! 'Auth token has expired'
      rescue ::JWT::DecodeError
        fail! 'Auth token is invalid'
      rescue ::Jwt::InvalidPayload
        fail! 'Invalid payload'
      rescue ::ActiveRecord::RecordNotFound
        fail! 'User not found'
      end
    end
  end
end
