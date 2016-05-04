class FriendshipsController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  def create
    @user = User.find(params[:friendship][:requested_id])
    current_user.send_friend_request_to(@user)

    respond_to do |format|
      format.html { redirect_to find_friends_path, notice: "Friend request sended to #{@user.first_name}." }
     end
  end

  def update
    current_user.accept_friend_request_from(@user)

   respond_to do |format|
      format.html { redirect_to find_friends_path, notice: "#{@user.first_name} is now your friend." }
    end
  end

  def destroy
    current_user.reject_friend_request_from(@user)
    respond_to do |format|
      format.html { redirect_to find_friends_path , notice: "The friend request from #{@user.first_name} has been deleted." }
    end
  end

  private
  def set_user
    @user = User.friendly.find(params[:id])
  end
  def friendship_params
    params.require(:friendship).permit(:requester_id, :requested_id)
  end
end
