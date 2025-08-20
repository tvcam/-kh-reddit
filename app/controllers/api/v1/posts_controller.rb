module Api
  module V1
    class PostsController < BaseController
      before_action :authenticate_user!, only: %i[create update destroy]

      def index
        posts = Post.includes(:community, :user).order(created_at: :desc).page(params[:page])
        render json: posts.as_json(only: %i[id title score comments_count post_type created_at], methods: [], include: { community: { only: %i[id name slug] }, user: { only: %i[id username] } })
      end

      def show
        post = Post.find(params[:id])
        render json: post.as_json(include: { user: { only: %i[id username] }, community: { only: %i[id name slug] }, comments: { only: %i[id body score parent_id created_at user_id] } })
      end

      def create
        post = current_user.posts.build(post_params.except(:media))
        if params[:post][:media].present?
          Array(params[:post][:media]).each { |io| post.media.attach(io) }
        end
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        post = current_user.posts.find(params[:id])
        if post.update(post_params.except(:media))
          if params[:post][:media].present?
            Array(params[:post][:media]).each { |io| post.media.attach(io) }
          end
          render json: post
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        post = current_user.posts.find(params[:id])
        post.destroy
        head :no_content
      end

      private

      def post_params
        params.require(:post).permit(:community_id, :title, :body, :url, :post_type, :media_data, media: [])
      end
    end
  end
end



