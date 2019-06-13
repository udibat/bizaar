class CertificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  include AllowTutorOnly

  def create
    @cert = @current_user.custom_profile.certifications.build(certification_params)

    if @cert.save
      render json: {
        existing_certifications: CertificationWizardDecorator.decorate_collection(
          @current_user.custom_profile.certifications)
      }, status: 200
    else
      render json: { error: @cert.errors.messages }, status: 422
    end

  end

private

  def certification_params
    params.require(:certification).permit(:id, :name, :category_id, :image)
  end

end

