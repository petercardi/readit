class PostsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    if @post.save
      flash[:notice] = "Post was created with GREAT SUCCESS"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Updated that schitt"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "BURN IT ALL"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_content)
  end

  def ensure_logged_in
    unless current_user
      redirect_to root_path, notice: "You must log in to do that"
    end
  end

end
