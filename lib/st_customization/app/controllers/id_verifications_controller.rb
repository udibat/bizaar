class IdVerificationsController < ApplicationController
  # skip_before_action :verify_authenticity_token

  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  before_action :find_id_vfc, only: [:update, :destroy, :show]

  skip_before_action :ensure_consent_given

  # include AllowTutorOnly

  def index
    render json: @current_user.custom_profile.id_verifications, status: 200
  end

  def show
    render json: @id_vfc, status: 200
  end

  def create
    @id_vfc = @current_user.custom_profile.id_verifications.build(id_verification_params)

    if @id_vfc.save
      render json: @id_vfc, status: 200
    else
      render json: { error: @id_vfc.errors.messages }, status: 422
    end

  end

  def update
    if @id_vfc.update_attributes(id_verification_params)
      render json: @id_vfc, status: 200
    else
      render json: { error: @id_vfc.errors.messages }, status: 422
    end
  end


  def destroy
    res = @id_vfc.destroy

    render json: res, status: 200
  end

private

  def id_verification_params
    params.require(:id_verification).permit(:id, :image, :identification_type)
  end

  def find_id_vfc
    @id_vfc = @current_user.custom_profile.id_verifications.find(params[:id])
  end

end

