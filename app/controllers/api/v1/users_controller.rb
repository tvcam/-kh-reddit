module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: user.as_json(only: %i[id username karma created_at])
      end
    end
  end
end


