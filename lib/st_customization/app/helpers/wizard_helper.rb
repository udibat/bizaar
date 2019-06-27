module WizardHelper

  def wizard_header_steps(user)

    signup_status = user.is_tutor? ? user.tutor_signup_status : user.member_signup_status
    
    prev_step_passed = false
    [
      {
        key_name: :registered,
        display_name: 'Basic Information',
      },
      {
        key_name: :email_verification_finished,
        display_name: 'Email Verification',
      },
      {
        key_name: :setup_profile,
        display_name: 'Set up your profile',
      },
      {
        key_name: :social_media,
        display_name: 'Bolster your profile',
      },
      {
        key_name: :id_verification,
        display_name: 'Verify your ID',

      },
      {
        key_name: :social_media,
        display_name: 'Bolster your profile',
      },
      {
        key_name: :payment_information,
        display_name: 'Set up payment',
      }
    ].select{|h|
      signup_status.class.signup_statuses[h[:key_name]].present?
    }.map{|h|
      h[:step_passed] = signup_status.step_marked_as_passed?(h[:key_name])
      h[:current_step] = (!h[:step_passed] && prev_step_passed)
      prev_step_passed = h[:step_passed]
      
      h
    }


  end

end

