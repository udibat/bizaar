require 'active_support/concern'

module TutorSignupExtension
  extend ActiveSupport::Concern

  included do

    after_action :mark_user_as_tutor, only: [:create]
    after_action :generate_validation_errors, only: [:create]
    after_action :update_signup_step_after_oauth_signup, only: [:update]

    alias_method :create_before_redef, :create
    def create

      # build username by first_name and last_name:
      username = "#{params['person']['given_name']}_#{params['person']['family_name']}".gsub(/[^0-9a-z_]/i, '')
      existing_cnt = Person.where("username LIKE ?", "#{username}%").count
      username = "#{username}_#{existing_cnt}" if existing_cnt > 0
      params['person']['username'] = username

      create_before_redef

    end

    private

    alias_method :person_create_params_before_redef, :person_create_params
    def person_create_params(params)
      birthday_permitted = parsed_birthday_params(params)
      params_before_redef = person_create_params_before_redef(params)
      birthday_permitted.each{|key, val|
        params_before_redef[key] = val
      }

      params_before_redef
    end

    alias_method :person_update_params_before_redef, :person_update_params
    def person_update_params(params, target_user)
      birthday_permitted = parsed_birthday_params(params)
      params_before_redef = person_update_params_before_redef(params, target_user)

      birthday_permitted.each{|key, val|
        params_before_redef[key] = val
      }

      params_before_redef
    end

  end

  # class_methods do

  # end

private

  def generate_validation_errors
    if @person.present? && !@person.valid? && @person.errors
      flash[:error] = @person.errors.messages.map{|k, v|
        "#{k}: #{v.to_a.join(',')}"
      }.join("\n")
    end
  end


  def mark_user_as_tutor
    user = Person.find_by_username(params['person']['username'])
    return unless user.present?
    user.mark_as_tutor!

    tutor_signup_status = user.tutor_signup_status
    tutor_signup_status.signup_status = :email_verification_sent
    tutor_signup_status.save!
  end

  def update_signup_step_after_oauth_signup
    # don't update signup status if error happened
    if params['update_after_social_signup'] && !(flash[:error].present?)
      tutor_signup_status = @current_user.tutor_signup_status
      return if tutor_signup_status.signup_status.to_sym != :registered_oauth
      tutor_signup_status.signup_status = :profile_picture
      tutor_signup_status.save!
    end
  end

  def parsed_birthday_params(params)
    birthday_permitted = {
      birthday: Date.civil(
        params[:person]["birthday(1i)"].to_i,
        params[:person]["birthday(2i)"].to_i,
        params[:person]["birthday(3i)"].to_i
      )
    }
    params[:person].delete('birthday')
    params[:person].delete('birthday(1i)')
    params[:person].delete('birthday(2i)')
    params[:person].delete('birthday(3i)')

    birthday_permitted
  end

end

