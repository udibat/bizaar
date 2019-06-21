module WizardHelper

  def wizard_header_steps(tutor_signup_status)

    # step_marked_as_passed?(step_name)
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
        key_name: :social_media,
        display_name: 'Bolster your profile',
      },
      {
        key_name: :id_verification,
        display_name: 'Verify your ID',

      },
      {
        key_name: :index,
        display_name: 'Set up payment',
      }

    ].map{|h|
      h[:step_passed] = tutor_signup_status.step_marked_as_passed?(h[:key_name])
      h
    }


  end

end

