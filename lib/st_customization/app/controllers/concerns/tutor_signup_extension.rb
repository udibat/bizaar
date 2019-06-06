require 'active_support/concern'

module TutorSignupExtension
  extend ActiveSupport::Concern

  included do

    after_action :mark_user_as_tutor, only: [:create]

    alias_method :create_before_redef, :create
    def create

      # build username by first_name and last_name:
      username = "#{params['person']['given_name']}_#{params['person']['family_name']}".gsub(/[^0-9a-z_]/i, '')
      existing_cnt = Person.where("username LIKE ?", "#{username}%").count
      username = "#{username}_#{existing_cnt}" if existing_cnt > 0
      params['person']['username'] = username

      create_before_redef

    end



  end



  # class_methods do

  # end

private

  def mark_user_as_tutor
    user = Person.find_by_username(params['person']['username'])
    user.is_tutor = true
    user.save!
    tutor_signup_status = user.build_tutor_signup_status
    tutor_signup_status.signup_status = :registered
    tutor_signup_status.save!
  end

end

