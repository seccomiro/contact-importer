module Devise
  module Failures
    class CustomFailureApp < Devise::FailureApp
      def respond
        # TODO: Possibly, this condition has the ability to mess with an eventual non-API JSON response.
        # TODO: It needs further verification.
        if request.format == :json
          json_error_response
        else
          super
        end
      end

      def json_error_response
        self.status = 401
        self.content_type = 'application/json'
        self.response_body = {
          status: :error,
          message: 'You need to sign in or sign up before continuing'
        }.to_json
      end
    end
  end
end
