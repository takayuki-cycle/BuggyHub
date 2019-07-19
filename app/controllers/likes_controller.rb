class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    @like = Like.new(user_id: @current_user.id, post_id: params[:post_id])
    guest = User.find_by(id: session[:user_id])
    if guest.id == -999
      flash[:notice] = "ゲストユーザーのためライクできません"
      redirect_to("/posts/#{params[:post_id]}")
    elsif guest.id != -999
      @like.save
      redirect_to("/posts/#{params[:post_id]}")
    end
  end

  def destroy
    @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
    @like.destroy
    redirect_to("/posts/#{params[:post_id]}")
  end
end