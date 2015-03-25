class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "Post was created with GREAT SUCCESS"
      redirect_to user_posts_path(current_user)
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
      redirect_to user_post_path(@user, @post)
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_content)
  end

end
