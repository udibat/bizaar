class Admin::UserQualificationsService
  attr_reader :community, :params, :current_user, :target_user

  # PER_PAGE = 50

  def initialize(community:, params:, current_user:, target_user:)
    raise "Current user should be admin!" unless current_user.has_admin_rights?(community)
    @params = params
    @community = community
    @current_user = current_user
    @target_user = target_user
  end


  def list_certifications
    @target_user.custom_profile.certifications
  end

  def approve_cert!(certification)
    certification.status = :approved
    certification.status_updated_at = DateTime.now.utc
    certification.status_updated_by = @current_user

    certification.save!

    certification
  end

  def reject_cert!(certification, rejection_reason = nil)
    certification.status = :rejected
    certification.status_updated_at = DateTime.now.utc
    certification.status_updated_by = @current_user
    certification.rejection_reason = rejection_reason

    certification.save!

    certification
  end

end

