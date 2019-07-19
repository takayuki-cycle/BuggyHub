class MapsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @maps = Map.all
    gon.js_maps = Map.all
    gon.js_user_session = User.find_by(id: session[:user_id])
    @users = User.all
  end

  def show
    @map = Map.find_by(id: params[:id])
    @user = User.find_by(id: @map.user_id)
    @posts = Post.page(params[:page]).per(5).where(review_id: @map.user_id)
    @user_reserve = User.find_by(id: @map.reserve_id)
  end

  def reserve
    @map = Map.find_by(id: params[:id])
    @map.reserve = 1
    @map.reserve_id = @current_user.id
    guest = User.find_by(id: session[:user_id])
    if guest.id == -999
      flash[:notice] = "ゲストユーザーのため予約できません"
      redirect_to("/maps/#{@map.id}")
    elsif guest.id != -999
      @map.save
      flash[:notice] = "エリアを予約しました(サービス提供者のメールアドレスから連絡を取り合いましょう！)"
      redirect_to("/maps/index")
    end
  end

  def new
    @map = Map.new
    @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.find_by(id: params[:id])
    @map = Map.new(
      storage: params[:storage],
      area: params[:area],
      service_start: Time.local(params[:service_start_year],
                                params[:service_start_month],
                                params[:service_start_day],
                                params[:service_start_hour],
                                params[:service_start_min]),
      service_end: Time.local(params[:service_end_year],
                              params[:service_end_month],
                              params[:service_end_day],
                              params[:service_end_hour],
                              params[:service_end_min]),
      ride: params[:ride],
      remark: params[:remark],
      name: params[:name], # hidden
      lat: cookies[:lat_new_map],
      lng: cookies[:lng_new_map],
      user_id: @current_user.id
    )
    guest = User.find_by(id: session[:user_id])
    if guest.id == -999
      flash.now[:notice] = "ゲストユーザーのため登録できません"
      render("maps/new")
    elsif guest.id != -999
      if @map.save
        flash[:notice] = "エリアを登録しました"
        redirect_to("/maps/index")
      else
        render("maps/new")
      end
    end
  end

  def edit
    @map = Map.find_by(id: params[:id])
  end

  def update
    @map = Map.find_by(id: params[:id])
    @map.storage = params[:storage]
    @map.area = params[:area]
    @map.service_start = Time.local(params[:service_start_year],
                                    params[:service_start_month],
                                    params[:service_start_day],
                                    params[:service_start_hour],
                                    params[:service_start_min])
    @map.service_end = Time.local(params[:service_end_year],
                              params[:service_end_month],
                              params[:service_end_day],
                              params[:service_end_hour],
                              params[:service_end_min])
    @map.ride = params[:ride]
    @map.remark = params[:remark]
    @map.name = params[:name] # hidden
    @map.lat = cookies[:lat_edit_map]
    @map.lng = cookies[:lng_edit_map]
    @map.user_id = @current_user.id

    if @map.save
      flash[:notice] = "エリアを編集しました"
      redirect_to("/maps/index")
    else
      render("maps/edit")
    end
  end

  def destroy
    @map = Map.find_by(id: params[:id])
    @map.destroy
    flash[:notice] = "エリアを削除しました"
    redirect_to("/maps/index")
  end

  def ensure_correct_user
    @map = Map.find_by(id: params[:id])
    if @map.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/maps/index")
    end
  end
end