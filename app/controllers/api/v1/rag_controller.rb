module Api
  module V1
    class RagController < BaseController
      def export
        since = Time.at(params[:since].to_i) if params[:since].present?
        posts = Post.where("created_at > ?", since || 100.years.ago).limit(1000)
        comments = Comment.where("created_at > ?", since || 100.years.ago).limit(1000)
        render json: {
          posts: posts.map { |p| serialize_post(p) },
          comments: comments.map { |c| serialize_comment(c) }
        }
      end

      private

      def serialize_post(p)
        {
          id: p.id,
          created_at: p.created_at,
          user_id: p.user_id,
          community_id: p.community_id,
          title: p.title,
          body: p.body,
          score: p.score
        }
      end

      def serialize_comment(c)
        {
          id: c.id,
          created_at: c.created_at,
          user_id: c.user_id,
          post_id: c.post_id,
          parent_id: c.parent_id,
          body: c.body,
          score: c.score
        }
      end
    end
  end
end



