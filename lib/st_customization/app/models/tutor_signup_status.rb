class TutorSignupStatus < ApplicationRecord

  belongs_to :person, foreign_key: "person_id"

  validates_presence_of :person


  enum signup_status: [
    :registered_oauth,  # fill up missing fields
    :registered,
    :email_verification_sent,
    :email_verification_finished,
    :qualifications, #optional step
    :profile_picture,
    :describe_yourself,
    :cover_photos, #optional step
    :social_media, #optional step
    :id_verification,
    :payment_information, #optional step
    :bizaar_pact,
    :finished
  ], _prefix: true

  def next_step!
    if next_step = next_step_name
      self.signup_status = next_step
      self.save!
    end

    next_step

  end

  def next_step_name
    statuses = self.class.signup_statuses
    next_step_idx = statuses[signup_status] + 1

    statuses.select{|k, v| v == next_step_idx }.keys.first

  end

  def show
    puts 'Basic'
  end

end

