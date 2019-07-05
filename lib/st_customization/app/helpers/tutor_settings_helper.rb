module TutorSettingsHelper


  def custom_settings_links_for(person, community=nil, restrict_for_admin=false)

    if person.is_tutor?
      tutor_settings_links(person, community, restrict_for_admin)
    else
      member_settings_links(person, community, restrict_for_admin)
    end

  end

  def member_settings_links(person, community=nil, restrict_for_admin=false)
    
    common_links = settings_links_for(person, community, restrict_for_admin)
    # replace bank account payment link with member payment link
    common_links.reject{|h| h[:id] == 'settings-tab-payments'} + [
      {
        :id => "settings-tab-member_payments",
        :text => t("layouts.settings.payments"),
        :icon_class => icon_class("thumbnails"),
        :path => member_payment_settings_path(person),
        :name => "Payments"
      },
      {
        :id => "settings-tab-id_verification",
        :text => t("layouts.settings.id_verification"),
        :icon_class => icon_class("thumbnails"),
        :path => person_id_verification_settings_path(person),
        :name => "id verification"
      },
    ]
  end


  def tutor_settings_links(person, community=nil, restrict_for_admin=false)
    settings_links_for(person, community, restrict_for_admin) + [
      {
        :id => "settings-tab-qualifications",
        :text => t("layouts.settings.qualifications"),
        :icon_class => icon_class("thumbnails"),
        :path => person_qualifications_settings_path(person),
        :name => "qualifications"
      },
      {
        :id => "settings-tab-id_verification",
        :text => t("layouts.settings.id_verification"),
        :icon_class => icon_class("thumbnails"),
        :path => person_id_verification_settings_path(person),
        :name => "id verification"
      },
    ]
  end

end