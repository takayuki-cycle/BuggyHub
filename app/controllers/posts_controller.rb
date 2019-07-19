class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @users = User.select("id", "name")
    @posts = Post.where.not(user_id: -1).page(params[:page]).per(7).order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @users = User.select("id", "name")
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @users = User.select("id", "name")
    @post = Post.new
  end

  def create
    @users = User.select("id", "name")
    @post = Post.new(
      content: params[:content],
      star: params[:star],
      review_id: params[:review_id],
      user_id: @current_user.id
    )
    guest = User.find_by(id: session[:user_id])
    if guest.id == -999
      flash.now[:notice] = "ゲストユーザーのため投稿できません"
      render("posts/new")
    elsif guest.id != -999
      if @post.save
        User.increment_counter(:total_review, params[:review_id]) # total_review++
        user = User.find_by(id: params[:review_id])
        total_star = Post.where(review_id: params[:review_id]).sum(:star)
        mean_star = total_star.fdiv(user.total_review)
        User.where(id: params[:review_id]).update_all(mean_star: mean_star) # mean_star
        flash[:notice] = "レビューを投稿しました"
        redirect_to("/posts/index")
      else
        render("posts/new")
      end
    end
  end

  def edit
    @users = User.select("id", "name")
    @post = Post.find_by(id: params[:id])
    gon.js_post = Post.find_by(id: params[:id])
  end

  def update
    review_id_old = Post.find_by(id: params[:id]) # Change mean_star
    @users = User.select("id", "name")
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    @post.star = params[:star]
    @post.review_id = params[:review_id]

    if @post.save
      # Destroy start
      User.decrement_counter(:total_review, review_id_old.review_id) # total_review--
      user_old = User.find_by(id: review_id_old.review_id)
      total_star_old = (Post.where(review_id: review_id_old.review_id).sum(:star))
      if user_old.total_review == 0 # Avoidance NaN(0/0)
        User.where(id: review_id_old.review_id).update_all(mean_star: 0) # mean_star = 0
      else
        mean_star_old = total_star_old.fdiv(user_old.total_review)
        User.where(id: review_id_old.review_id).update_all(mean_star: mean_star_old) # mean_star
      end
      # Destroy end
      # Create start
      User.increment_counter(:total_review, params[:review_id]) # total_review++
      user = User.find_by(id: params[:review_id])
      total_star = Post.where(review_id: params[:review_id]).sum(:star)
      if user.total_review == 0 # Avoidance infinite(x/0)
        User.where(id: params[:review_id]).update_all(mean_star: 0) # mean_star = 0
      else
        mean_star = total_star.fdiv(user.total_review)
        User.where(id: params[:review_id]).update_all(mean_star: mean_star) # mean_star
      end
      # Create end
      flash[:notice] = "レビューを編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    review_id_old = Post.find_by(id: params[:id]) # Change mean_star
    @post = Post.find_by(id: params[:id])
    @post.destroy
    User.decrement_counter(:total_review, review_id_old.review_id) # total_review--
    user_old = User.find_by(id: review_id_old.review_id)
    total_star_old = (Post.where(review_id: review_id_old.review_id).sum(:star))
    if user_old.total_review == 0 # Avoidance NaN(0/0)
      User.where(id: review_id_old.review_id).update_all(mean_star: 0) # mean_star = 0
    else
      mean_star_old = total_star_old.fdiv(user_old.total_review)
      User.where(id: review_id_old.review_id).update_all(mean_star: mean_star_old) # mean_star
    end
    flash[:notice] = "レビューを削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end