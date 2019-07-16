class Admin::UserQualificationsController < Admin::AdminBaseController
  before_action :find_user
  before_action :setup_service
  before_action :find_cert, only: [:approve, :reject]

  # Show available qualifications for the user
  def index
    @certifications = CertificationWizardDecorator.decorate_collection(
      @service.list_certifications.order(status: :asc)
    )
  end

  def approve
    render json: @service.approve_cert!(@cert)
  end

  def reject
    render json: @service.reject_cert!(@cert, params['rejection_reason'])
  end

private

  def find_cert
    @cert = @target_user.custom_profile.certifications.find(params[:id])
  end

  def find_user
    @target_user = Person.find_by_username!(params['person_id'])
  end

  def setup_service
    @service  = Admin::UserQualificationsService.new(
      community: @current_community,
      params: params,
      current_user: @current_user,
      target_user: @target_user
    )
  end

end

