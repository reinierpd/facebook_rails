class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @post = Post.new
  end
end
