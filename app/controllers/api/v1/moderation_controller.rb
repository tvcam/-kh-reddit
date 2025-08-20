module Api
  module V1
    class ModerationController < BaseController
      before_action :authenticate_user!

      def remove_post
        post = Post.find(params[:post_id])
        authorize_moderator!(post.community)
        post.destroy
        ModerationAction.create!(community: post.community, actor: current_user, target: post, action_type: :remove_post, reason: params[:reason])
        head :no_content
      end

      def pin_post
        post = Post.find(params[:post_id])
        authorize_moderator!(post.community)
        post.update!(pinned: true)
        ModerationAction.create!(community: post.community, actor: current_user, target: post, action_type: :pin_post)
        head :no_content
      end

      def remove_comment
        comment = Comment.find(params[:comment_id])
        authorize_moderator!(comment.post.community)
        comment.destroy
        ModerationAction.create!(community: comment.post.community, actor: current_user, target: comment, action_type: :remove_comment, reason: params[:reason])
        head :no_content
      end

      private

      def authorize_moderator!(community)
        membership = Membership.find_by(user: current_user, community: community)
        allowed = membership&.moderator? || membership&.admin?
        render json: { error: 'Forbidden' }, status: :forbidden unless allowed
      end
    end
  end
end



