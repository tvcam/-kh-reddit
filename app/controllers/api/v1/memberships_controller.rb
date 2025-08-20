module Api
  module V1
    class MembershipsController < BaseController
      before_action :authenticate_user!

      def create
        community = Community.find_by!(slug: params[:community_id])
        membership = Membership.find_or_initialize_by(user: current_user, community: community)
        membership.status ||= :active
        membership.role ||= :member
        if membership.save
          render json: { joined: true, members_count: community.reload.members_count }
        else
          render json: { errors: membership.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        community = Community.find_by!(slug: params[:community_id])
        membership = Membership.find_by(user: current_user, community: community)
        membership&.destroy
        render json: { joined: false, members_count: community.reload.members_count }
      end
    end
  end
end


