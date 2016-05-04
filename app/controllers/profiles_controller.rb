class ProfilesController < ApplicationController
  before_action :authorize_self_profile, only:[:edit, :update]
  before_action :set_profile, only: [:show, :update]
  # before_action :authorize_public_profile, only: [:show]

  def show
    @friends = current_user.friends
  end

  def edit
    @profile = current_user.profile
  end

  def update
    new_profile_params = profile_params

    if new_profile_params[:profile_img_id] != nil
      new_profile_image = Picture.create({:content=> new_profile_params[:profile_img_id]})
      new_profile_params[:profile_img_id]= new_profile_image.id
    end
    if new_profile_params[:poster_img_id] != nil
      new_poster_image = Picture.create({:content=> new_profile_params[:poster_img_id]})
      new_profile_params[:poster_img_id]= new_poster_image.id

    end

    if @profile.update(new_profile_params)
      redirect_to @profile, notice: "Profile updated."
    else
      render "edit"
    end
  end

  private
  def set_profile
    @profile = User.friendly.find(params[:id]).profile
  end

  def authorize_self_profile
    user= User.friendly.find(params[:id])
    if user.id != current_user.id
     redirect_to root_path , :notice => "You can change only your profile"
    end
  end

  def authorize_public_profile
    user = Profile.find(params[:id]).user
    msg = "This profile is private"
  end

  def profile_params
    params.require(:profile).permit(:avatar, :birthday, :country, :education, :profession, :about_you, :profile_img_id, :poster_img_id)
  end
end
