class MemberSignupStatus < ApplicationRecord
  include SignupStatusLogic

  SKIPPABLE_STEPS = [:cover_photos, :qualifications, :social_media, :payment_information]

  enum signup_status: [
    :registered,
    :email_verification_sent,
    :email_verification_finished,
    :registered_oauth,  # fill up missing fields
    :setup_profile,
    :payment_information,
    # :index, #optional step (payment_information)
    :bizaar_pact,
    :finished
  ], _prefix: true

  def check_step_completeness(step_name)
    case step_name.to_sym
    when :registered_oauth
      # person.valid?
      person.birthday.present? && person.zip_code.present? && person.allowed_age?
    when :setup_profile
      (person.custom_profile.avatar.present? &&
        person.custom_profile.description.present?) rescue false
    when :payment_information
      person.stripe_account.try(:stripe_customer_id).present? rescue false
    when :bizaar_pact
      person.custom_profile.pact_accepted? rescue false
    else
      false
      # raise "unknown step: '#{step_name}'."
    end
  end

end

