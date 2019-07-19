class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update, :destroy, :likes, :maps, :maps_no_reserve, :maps_be_reserved, :maps_reserved]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login, :guest]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @users = User.select("id", "name")
    @user = User.find_by(id: params[:id])
    @user_posts = Post.page(params[:page]).per(5).where(user_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: params[:image],
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.image_name = params[:image]

    if @user.id == -999
      flash.now[:notice] = "ゲストユーザーのため編集できません"
      render("users/edit")
    elsif @user.id != -999
      if @user.save
        Map.where(user_id: params[:id]).update(name: params[:name])
        flash[:notice] = "ユーザー情報を編集しました"
        redirect_to("/users/#{@user.id}")
      else
        render("users/edit")
      end
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def guest
    if User.find_by(id: "-999")
      session[:user_id] = "-999"
      flash[:notice] = "ゲストユーザーでログインしました"
      redirect_to("/users/index")
    else
      @user = User.new(
        id: "-999",
        name: "ゲストユーザー",
        email: "guest@BuggyHub.com",
        image_name: "guest20190715.svg",
        password: "guest"
      )
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "ゲストユーザーでログインしました"
        redirect_to("/users/index")
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.page(params[:page]).per(5).where(user_id: @user.id)
  end

  def maps_no_reserve
    @user = User.find_by(id: params[:id])
    @maps = Map.page(params[:page]).per(5).where(user_id: @user.id).where(reserve: 0)
  end

  def maps_be_reserved
    @user = User.find_by(id: params[:id])
    @maps = Map.page(params[:page]).per(5).where(user_id: @user.id).where(reserve: 1)
  end

  def maps_reserved
    @user = User.find_by(id: params[:id])
    @maps = Map.page(params[:page]).per(5).where(reserve_id: @user.id).where(reserve: 1)
  end

  def destroy
    guest = User.find_by(id: params[:id])
    if guest.id == -999
      flash[:notice] = "ゲストユーザーのため削除できません"
      redirect_to("/users/-999")
    elsif guest.id != -999

      # Like table
      @likes = Like.where(user_id: params[:id])
      @likes.destroy_all
      posts = Post.where(user_id: params[:id])
      likes = Like.all
      posts.each do |post|
        likes.each do |like|
          likes_des = Like.where(post_id: post.id)
          likes_des.destroy_all
        end
      end

      # Post table
      Post.where(user_id: params[:id]).update_all(user_id: -1)  # レビュー先の評価を残すため
      @posts = Post.where(review_id: params[:id])
      @posts.destroy_all

      # Map table
      Map.where(reserve_id: params[:id]).update_all(reserve: 0)
      Map.where(reserve_id: params[:id]).update_all(reserve_id: nil)  # 再び予約できるようにする
      @maps = Map.where(user_id: params[:id])
      @maps.destroy_all

      # User table
      @user = User.find_by(id: params[:id])
      @user.destroy

      flash[:notice] = "アカウントを削除しました"
      redirect_to("/")
    end
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end