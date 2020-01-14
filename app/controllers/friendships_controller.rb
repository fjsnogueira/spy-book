class FriendshipsController < ApplicationController
  def create
    return if current_user.id == params[:user_id] # Disallow the ability to send yourself a friend request

    @friendship = current_user.friend_sent.build(sent_to_id: params[:user_id])
    if @friendship.save
      flash[:success] = 'Friend Request Sent!'
    else
      flash[:danger] = 'Friend Request Failed!'
    end
    redirect_back(fallback_location: root_path)
  end

  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.status = true
    if @friendship.save
      flash[:success] = 'Friend Request Accepted!'
    else
      flash[:danger] = 'Friend Request could not be accepted!'
    end
    redirect_back(fallback_location: root_path)
  end

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.destroy
    flash[:success] = 'Friend Request Declined!'
    redirect_back(fallback_location: root_path)
  end
end