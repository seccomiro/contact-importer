class Api::V1::AuthController < Api::V1::ApiController
  skip_before_action :authenticate_user!

  def sign_up
    @user = User.create!(sign_up_params)
  end

  def sign_in
    @user = User.find_by(email: params[:email])
    return json_fail_response('Invalid email or password', :unauthorized) unless @user&.valid_password?(params[:password])
  end

  private

  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name)
  end
end
