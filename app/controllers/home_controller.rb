class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
   @posts = current_user.posts.order('created_at  desc')
  end
end
