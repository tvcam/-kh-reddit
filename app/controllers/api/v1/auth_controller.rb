module Api
  module V1
    class AuthController < BaseController
      def sign_up
        user = User.new(user_params)
        if user.save
          render json: { user: user.as_json(only: %i[id username email phone]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def sign_in
        user = User.find_for_authentication(email: params[:email])
        if user&.valid_password?(params[:password])
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
          render json: { token: token, user: user.as_json(only: %i[id username email phone]) }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def sign_out
        head :no_content
      end

      def request_otp
        user = User.find_by(phone: params[:phone])
        return render json: { error: "User not found" }, status: :not_found unless user

        code = format("%06d", rand(0..999_999))
        OtpCode.create!(user: user, code: code, expires_at: 10.minutes.from_now, channel: :sms)
        render json: { ok: true }
      end

      def verify_otp
        user = User.find_by(phone: params[:phone])
        return render json: { error: "User not found" }, status: :not_found unless user
        otp = OtpCode.active.find_by(user: user, code: params[:code])
        return render json: { error: "Invalid or expired OTP" }, status: :unauthorized unless otp
        otp.update!(consumed_at: Time.current)
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        render json: { token: token, user: user.as_json(only: %i[id username email phone]) }
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :phone)
      end
    end
  end
end


