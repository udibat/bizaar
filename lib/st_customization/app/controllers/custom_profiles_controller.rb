class CustomProfilesController < ApplicationController
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end


  def update
    @custom_profile = CustomProfile.find(params[:id])
    if @custom_profile.update_attributes(custom_profile_update_params)
      flash[:notice] = 'Profile was successfully updated.'
    else
      flash[:error] = @custom_profile.errors.first.to_s
    end

    redirect_back fallback_location: homepage_url

  end

  def upload_avatar
    @custom_profile = CustomProfile.find(params[:id])
    if @custom_profile.update_attributes(custom_profile_update_params)
      # flash[:notice] = 'Profile was successfully updated.'
      render json: {image_url: @custom_profile.avatar.url(:thumb)}
    else
      # flash[:error] = @custom_profile.errors.first.to_s
      render json: {error: @custom_profile.errors.first.to_s}
    end
  end

private

  def custom_profile_update_params
    params.require(:custom_profile).permit(
        :avatar
      )
  end

end

