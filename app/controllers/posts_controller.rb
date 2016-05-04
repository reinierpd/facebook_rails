class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :add_like]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    new_post_params = post_params
    if new_post_params[:image] != nil
    new_image = Picture.create({:content=> new_post_params[:image]})
      new_post_params[:image]= new_image
    end
    @post = Post.new(new_post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
        format.js
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_like
    @user = current_user
    @user.toggle_like!(@post)
    respond_to do |format|
      format.js
    end
  end

  def comment
    @post = Post.find(params[:post_id])
    comment = @post.comments.create
    comment.comment = params[:comment][:comment]
    comment.user = current_user
    comment.save
    #byebug

    respond_to do |format|
      format.js
    end

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :content, :image)
    end
end
