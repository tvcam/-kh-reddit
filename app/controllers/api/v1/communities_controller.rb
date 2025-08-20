module Api
  module V1
    class CommunitiesController < BaseController
      def index
        communities = Community.order(created_at: :desc).page(params[:page])
        render json: communities.as_json(only: %i[id name slug description members_count posts_count visibility nsfw])
      end

      def show
        community = Community.find_by!(slug: params[:id])
        posts = community.posts.pinned_first.page(params[:page])
        render json: {
          community: community.as_json(only: %i[id name slug description rules members_count posts_count visibility nsfw]),
          posts: posts.as_json(only: %i[id title score comments_count post_type created_at pinned])
        }
      end

      def create
        community = Community.new(community_params.merge(creator: current_user))
        if community.save
          render json: community, status: :created
        else
          render json: { errors: community.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def current_user
        # For now, use header-based user id in dev; will use JWT once sessions are wired
        User.find_by(id: request.headers["X-User-Id"]) if request.headers["X-User-Id"].present?
      end

      def community_params
        params.require(:community).permit(:name, :slug, :description, :rules, :visibility, :nsfw)
      end
    end
  end
end


