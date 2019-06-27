class MemberSignupStatus < ApplicationRecord
  include SignupStatusLogic

  SKIPPABLE_STEPS = [:cover_photos, :qualifications, :social_media, :index]

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

end

