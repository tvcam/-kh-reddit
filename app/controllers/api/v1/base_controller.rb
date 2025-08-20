module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::MimeResponds

      before_action :set_locale

      private

      def set_locale
        I18n.locale = request.headers["X-Locale"].presence || :km
      end

      def current_user
        auth_header = request.headers["Authorization"]
        return nil unless auth_header&.start_with?("Bearer ")
        token = auth_header.split(" ", 2)[1]
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)
        User.find_by(id: payload["sub"]) if payload
      rescue StandardError
        nil
      end

      def authenticate_user!
        return if current_user.present?
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end


