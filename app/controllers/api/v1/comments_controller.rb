module Api
  module V1
    class CommentsController < BaseController
      before_action :authenticate_user!, only: %i[create update destroy]

      def index
        comments = Comment.where(post_id: params[:post_id]).order(created_at: :asc)
        render json: comments.as_json(only: %i[id body score parent_id user_id created_at])
      end

      def create
        comment = current_user.comments.build(comment_params)
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        comment = current_user.comments.find(params[:id])
        if comment.update(comment_params)
          render json: comment
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        comment = current_user.comments.find(params[:id])
        comment.destroy
        head :no_content
      end

      private

      def comment_params
        params.require(:comment).permit(:post_id, :body, :parent_id)
      end
    end
  end
end



