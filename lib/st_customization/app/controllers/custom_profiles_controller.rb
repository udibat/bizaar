class CustomProfilesController < ApplicationController
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  before_action :load_profile

  def update
    if @custom_profile.update_attributes(custom_profile_update_params)
      flash[:notice] = 'Profile was successfully updated.'
    else
      flash[:error] = @custom_profile.errors.first.to_s
    end

    respond_to do |format|
      format.html {
        # Get rid of `free_navigation` if present
        uri = URI.parse(request.referer)
        h = Rack::Utils.parse_nested_query(uri.query)
        h.delete('free_navigation')
        uri.query = h.to_query

        redirect_to uri.to_s
      }
      format.json {
        render json: @custom_profile
      }
    end

  end

  def upload_avatar
    if @custom_profile.update_attributes(custom_profile_update_params)
      # flash[:notice] = 'Profile was successfully updated.'
      render json: {image_url: @custom_profile.avatar.url(:thumb)}
    else
      # flash[:error] = @custom_profile.errors.first.to_s
      render json: {error: @custom_profile.errors.first.to_s}
    end
  end

  def upload_cover_photos
    if @custom_profile.update_attributes(custom_profile_update_params)
      render json: {images: @custom_profile.cover_photos.map{|ph| 
          {
            id: ph.id,
            is_primary_photo: ph.is_primary_photo,
            url: ph.image.url(:thumb),
            name: ph.image.try(:original_filename),
          } 
        }}
    else
      render json: {error: @custom_profile.errors.first.to_s}
    end
  end

  def upload_id_verifications
    if @custom_profile.update_attributes(custom_profile_update_params)
      render json: {images: @custom_profile.id_verifications.map{|ph| 
          {
            id: ph.id,
            url: ph.image.url(:thumb),
            name: ph.image.try(:original_filename),
          } 
        }}
    else
      render json: {error: @custom_profile.errors.first.to_s}
    end
  end

private

  def load_profile
    @custom_profile = CustomProfile.find(params[:id])
  end

  def custom_profile_update_params
    if params[:custom_profile][:cover_photos_attributes].present?
      params[:custom_profile][:cover_photos_attributes].keys.each{|k|
        params[:custom_profile][:cover_photos_attributes][k.to_s].permit(:id, :_destroy, :image, :is_primary_photo)
      }
    end

    if params[:custom_profile][:id_verifications_attributes].present?
      params[:custom_profile][:id_verifications_attributes].keys.each{|k|
        params[:custom_profile][:id_verifications_attributes][k.to_s].permit(:id, :_destroy, :image)
      }
    end
    
    params.require(:custom_profile).permit(
        :avatar, :description,
        :social_link_facebook, :social_link_twitter, :social_link_instagram,
        :social_link_youtube, :social_link_twitch, :social_link_vimeo,
        :pact_accepted,
        cover_photos_attributes: {}, id_verifications_attributes: {}
      )
  end

end

