module Api
  module V1
    class NotificationsController < BaseController
      before_action :authenticate_user!

      def index
        notifications = Notification.where(user: current_user).order(created_at: :desc).limit(50)
        render json: notifications.as_json(only: %i[id notification_type read_at created_at], methods: [], include: { notifiable: { only: %i[id] } })
      end

      def mark_read
        Notification.where(user: current_user, id: params[:id]).update_all(read_at: Time.current)
        head :no_content
      end
    end
  end
end



