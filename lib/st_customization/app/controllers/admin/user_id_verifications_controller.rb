class Admin::UserIdVerificationsController < Admin::AdminBaseController
  before_action :find_user
  before_action :setup_service
  before_action :find_id_vfc, only: [:approve, :reject]

  # Show available qualifications for the user
  def index
    @id_vfc = @service.find_id_verification
  end

  def approve
    render json: @service.approve_id_vfc!(@id_vfc)
  end

  def reject
    render json: @service.reject_id_vfc!(@id_vfc, params['rejection_reason'])
  end

private

  def find_id_vfc
    @id_vfc = @service.find_id_verification.first
  end

  def find_user
    @target_user = Person.find_by_username!(params['person_id'])
  end

  def setup_service
    @service  = Admin::UserIdVerificationService.new(
      community: @current_community,
      params: params,
      current_user: @current_user,
      target_user: @target_user
    )
  end

end

