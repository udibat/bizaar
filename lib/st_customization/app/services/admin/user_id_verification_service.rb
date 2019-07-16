class Admin::UserIdVerificationService
  attr_reader :community, :params, :current_user, :target_user

  # PER_PAGE = 50

  def initialize(community:, params:, current_user:, target_user:)
    raise "Current user should be admin!" unless current_user.has_admin_rights?(community)
    @params = params
    @community = community
    @current_user = current_user
    @target_user = target_user
  end


  def find_id_verification
    @target_user.custom_profile.id_verifications.limit(1)
  end

  def approve_id_vfc!(id_vfc)
    id_vfc.status = :approved
    id_vfc.status_updated_at = DateTime.now.utc
    id_vfc.status_updated_by = @current_user.id

    id_vfc.save!

    id_vfc
  end

  def reject_id_vfc!(id_vfc, rejection_reason = nil)
    id_vfc.status = :rejected
    id_vfc.status_updated_at = DateTime.now.utc
    id_vfc.status_updated_by = @current_user.id
    id_vfc.rejection_reason = rejection_reason

    id_vfc.save!

    id_vfc
  end

end

