module Jwt
  class InvalidPayload < StandardError
    def initialize
      super('Invalid payload')
    end
  end
end
