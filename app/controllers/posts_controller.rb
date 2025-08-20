class PostsController < ApplicationController
  before_action :set_community

  def new
    @post = @community.posts.build
  end

  def create
    @post = @community.posts.build(post_params.merge(user: current_user))
    if @post.save
      redirect_to community_path(@community.slug), notice: t("post.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_community
    @community = Community.find_by!(slug: params[:community_id])
  end

  def current_user
    User.first
  end

  def post_params
    params.require(:post).permit(:title, :body, :url, :post_type, media: [])
  end
end


