module Api
  module V1
    class VotesController < BaseController
      before_action :authenticate_user!

      def create
        votable = find_votable
        vote = Vote.find_or_initialize_by(user: current_user, votable: votable)
        vote.value = vote_params[:value].to_i
        if vote.save
          update_scores!(votable)
          render json: { score: votable.score }
        else
          render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def vote_params
        params.require(:vote).permit(:votable_type, :votable_id, :value)
      end

      def find_votable
        klass = vote_params[:votable_type].constantize
        klass.find(vote_params[:votable_id])
      end

      def update_scores!(votable)
        score = Vote.where(votable: votable).sum(:value)
        votable.update!(score: score)
      end
    end
  end
end



