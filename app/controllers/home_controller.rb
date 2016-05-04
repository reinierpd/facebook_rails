class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
   @posts = current_user.post_feed
  end

  def find_friends
    @no_friends = current_user.no_friendship

    @friend_requests = current_user.requests_from
  end
end
