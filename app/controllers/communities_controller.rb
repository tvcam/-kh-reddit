class CommunitiesController < ApplicationController
  def index
    @communities = Community.order(created_at: :desc).page(params[:page])
  end

  def show
    @community = Community.find_by!(slug: params[:id])
    @posts = @community.posts.pinned_first.page(params[:page])
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params.merge(creator: current_user))
    if @community.save
      redirect_to @community, notice: t("community.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def current_user
    # demo: find first user if not using full auth in HTML
    User.first
  end

  def community_params
    params.require(:community).permit(:name, :slug, :description, :rules, :visibility, :nsfw)
  end
end


