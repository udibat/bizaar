class TutorSignupStatus < ApplicationRecord
  include SignupStatusLogic

  # belongs_to :person, foreign_key: "person_id"

  # validates_presence_of :person

  SKIPPABLE_STEPS = [:cover_photos, :qualifications, :social_media, :index]

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

  # def step_marked_as_passed?(step_name)
  #   current_step_idx = self.class.signup_statuses[signup_status]
  #   step_idx = self.class.signup_statuses[step_name]

  #   step_idx < current_step_idx
    
  # end

  # def try_skip_step!(step_name)
  #   return false unless SKIPPABLE_STEPS.include?(step_name.to_sym)

  #   sorted_steps = []
  #   TutorSignupStatus.signup_statuses.each{|k, v| sorted_steps[v] = k }
  #   check_curr_step_number = sorted_steps.index(signup_status.to_s)
  #   curr_step_number = sorted_steps.index(step_name)
  #   return false unless curr_step_number

  #   # prevent skipping multiple steps
  #   return false if check_curr_step_number < curr_step_number
    
  #   next_step_number = curr_step_number + 1
  #   next_step = sorted_steps[next_step_number]
  #   if next_step
  #     self.signup_status = next_step 
  #     self.save!
  #   end

  #   false
  # end

  # def next_step_if_complete!(curr_step_name = nil)
  #   if check_step_completeness(curr_step_name || signup_status)
  #     self.next_step!(curr_step_name || signup_status)
  #   end
  # end

  def check_step_completeness(step_name)
    case step_name.to_sym
    when :registered_oauth
      person.valid?
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

  # def next_step!(curr_step_name = nil)
  #   if next_step = next_step_name(curr_step_name)
  #     self.signup_status = next_step
  #     self.save!
  #   end

  #   next_step

  # end

  # def prev_step!
  #   if prev_step = self.prev_step_name
  #     self.signup_status = prev_step
  #     self.save!
  #   end

  #   prev_step
  # end

  # def next_step_name(target_step_name = nil)
  #   statuses = self.class.signup_statuses
  #   next_step_idx = statuses[target_step_name || signup_status] + 1

  #   statuses.select{|k, v| v == next_step_idx }.keys.first

  # end

  # def prev_step_name(target_step_name = nil)
  #   statuses = self.class.signup_statuses
  #   prev_step_idx = statuses[target_step_name || signup_status] - 1

  #   return if prev_step_idx <= 0

  #   statuses.select{|k, v| v == prev_step_idx }.keys.first
  # end

end

