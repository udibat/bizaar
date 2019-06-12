class TutorSignupStatus < ApplicationRecord

  belongs_to :person, foreign_key: "person_id"

  validates_presence_of :person

  SKIPPABLE_STEPS = [:cover_photos, :qualifications, :social_media, :payment_information]

  enum signup_status: [
    :registered_oauth,  # fill up missing fields
    :registered,
    :email_verification_sent,
    :email_verification_finished,
    :profile_picture,
    :describe_yourself,
    :cover_photos, #optional step
    :qualifications, #optional step
    :social_media, #optional step
    :id_verification,
    :payment_information, #optional step
    :bizaar_pact,
    :finished
  ], _prefix: true

  def try_skip_step!(step_name)
    return false unless SKIPPABLE_STEPS.include?(step_name.to_sym)

    sorted_steps = []
    TutorSignupStatus.signup_statuses.each{|k, v| sorted_steps[v] = k }
    check_curr_step_number = sorted_steps.index(signup_status.to_s)
    curr_step_number = sorted_steps.index(step_name)
    return false unless curr_step_number

    # prevent skipping multiple steps
    return false if check_curr_step_number < curr_step_number
    
    next_step_number = curr_step_number + 1
    next_step = sorted_steps[next_step_number]
    if next_step
      self.signup_status = next_step 
      self.save!
    end

    false
  end

  def next_step_if_complete!
    if check_step_completeness(signup_status)
      self.next_step!
    end
  end

  def check_step_completeness(step_name)
    case step_name.to_sym
    when :profile_picture
      person.custom_profile.avatar.present? rescue false
    when :describe_yourself
      person.custom_profile.description.present? rescue false
    when :cover_photos
      person.custom_profile.cover_photos.count > 0 rescue false
    else
      false
      # raise "unknown step: '#{step_name}'."
    end
  end

  def next_step!
    if next_step = next_step_name
      self.signup_status = next_step
      self.save!
    end

    next_step

  end

  def next_step_name(target_step_name = nil)
    statuses = self.class.signup_statuses
    next_step_idx = statuses[target_step_name || signup_status] + 1

    statuses.select{|k, v| v == next_step_idx }.keys.first

  end

  def prev_step_name(target_step_name = nil)
    statuses = self.class.signup_statuses
    prev_step_idx = statuses[target_step_name || signup_status] - 1

    return if prev_step_idx <= 0

    statuses.select{|k, v| v == prev_step_idx }.keys.first
  end

end

