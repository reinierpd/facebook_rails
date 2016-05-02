class ProfilesController < ApplicationController
  before_action :authorize_self_profile, only:[:edit, :update]
  # before_action :authorize_public_profile, only: [:show]

  def show
   @profile = current_user.profile
  end

  def edit
    @profile = current_user.profile
  end

  def update
    new_profile_params = profile_params
    if new_profile_params[:profile_img] != nil
      new_profile_image = Picture.create({:content=> new_profile_params[:profile_img]})
      new_profile_params[:profile_img]= new_profile_image
    end
    if new_profile_params[:poster_img] != nil
      new_poster_image = Picture.create({:content=> new_profile_params[:poster_img]})
      new_profile_params[:poster_img]= new_poster_image
    end
    @profile = Profile.find(params[:id])

    if @profile.update(new_profile_params)
      redirect_to @profile, notice: "Profile updated."
    else
      render "edit"
    end
  end

  private

  def authorize_self_profile
    user= Profile.find(params[:id]).user
    msg = "You can change only your profile"
     #authorize_user!(user,:self,msg)
  end

  def authorize_public_profile
    user = Profile.find(params[:id]).user
    msg = "This profile is private"
  end

  def profile_params
    params.require(:profile).permit(:avatar, :birthday, :country, :education, :profession, :about_you, :profile_img, :poster_img)
  end
end
