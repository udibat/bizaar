class TutorSignupStatus < ApplicationRecord
  include SignupStatusLogic

  SKIPPABLE_STEPS = [:qualifications, :social_media, :index]

  enum signup_status: [
    :registered,
    :email_verification_sent,
    :email_verification_finished,
    :registered_oauth,  # fill up missing fields
    :profile_picture,
    :describe_yourself,
    :cover_photos, #optional step
    :qualifications, #optional step
    :social_media, #optional step
    :id_verification,
    :index, #optional step (payment_information)
    :bizaar_pact,
    :finished
  ], _prefix: true

  def check_step_completeness(step_name)
    case step_name.to_sym
    when :registered_oauth
      person.birthday.present? && person.zip_code.present? && person.allowed_age?
    when :profile_picture
      person.custom_profile.avatar.present? rescue false
    when :describe_yourself
      person.custom_profile.description.present? rescue false
    when :cover_photos
      person.custom_profile.cover_photos.count > 0 rescue false
    when :qualifications
      # optional step
      person.custom_profile.certifications.count > 0 rescue false
      # true
    when :social_media
      # optional step
      person.custom_profile.attributes.select{|k|
        [
          :social_link_facebook, :social_link_twitter, :social_link_instagram,
          :social_link_youtube, :social_link_twitch, :social_link_vimeo
        ].include? k.to_sym
      }.values.map{|v| v.present?}.any?
    when :id_verification
      person.custom_profile.id_verifications.count > 0 rescue false
    when :index
      person.stripe_account.try(:stripe_seller_id).present? rescue false
    when :bizaar_pact
      person.custom_profile.pact_accepted? rescue false
    else
      false
      # raise "unknown step: '#{step_name}'."
    end
  end

end

