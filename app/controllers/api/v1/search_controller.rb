module Api
  module V1
    class SearchController < BaseController
      def index
        q = params[:q].to_s.strip
        return render json: { results: [] } if q.blank?
        posts = Post.where("tsv @@ plainto_tsquery('simple', ?)", q).limit(20)
        comments = Comment.where("tsv @@ plainto_tsquery('simple', ?)", q).limit(20)
        render json: {
          posts: posts.as_json(only: %i[id title score comments_count created_at], include: { community: { only: %i[id name slug] } }),
          comments: comments.as_json(only: %i[id body score post_id created_at])
        }
      end
    end
  end
end



