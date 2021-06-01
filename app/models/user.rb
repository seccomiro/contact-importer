class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :contacts, dependent: :destroy
  has_many :imports, dependent: :destroy
  has_many :import_contacts, through: :imports

  def token
    raise 'The user must be persisted in order to generate a JWT token' unless id

    JsonWebToken.encode(id: id)
  end

  def self.from_token(token)
    payload = JsonWebToken.decode(token)
    raise Jwt::InvalidPayload unless payload.key?('id')

    find(payload['id'])
  end
end
