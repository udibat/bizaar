module TutorSettingsHelper


  def custom_settings_links_for(person, community=nil, restrict_for_admin=false)

    links_arr = if person.is_tutor?
      tutor_settings_links(person, community, restrict_for_admin)
    else
      member_settings_links(person, community, restrict_for_admin)
    end

    links_arr + [
      {
        :id => "settings-tab-logout",
        :text => t('community_memberships.new.log_out'),
        :icon_class => icon_class("thumbnails"),
        :path => logout_path,
        :name => "Log out"
      },
    ]

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
        :name => "payments"
      },
      {
        :id => "settings-tab-id_verification",
        :text => 'Id verification',
        :icon_class => icon_class("thumbnails"),
        :path => person_id_verification_settings_path(person),
        :name => "id_verification"
      },
      {
        :id => "settings-tab-social_media",
        :text => 'Social Media',
        :icon_class => icon_class("thumbnails"),
        :path => person_social_media_settings_path(person),
        :name => "social_media"
      },
    ]
  end


  def tutor_settings_links(person, community=nil, restrict_for_admin=false)
    settings_links_for(person, community, restrict_for_admin) + [
      {
        :id => "settings-tab-qualifications",
        :text => 'Qualifications',
        :icon_class => icon_class("thumbnails"),
        :path => person_qualifications_settings_path(person),
        :name => "qualifications"
      },
      {
        :id => "settings-tab-id_verification",
        :text => 'Id verification',
        :icon_class => icon_class("thumbnails"),
        :path => person_id_verification_settings_path(person),
        :name => "id_verification"
      },
      {
        :id => "settings-tab-cover_photos",
        :text => 'Cover photos',
        :icon_class => icon_class("thumbnails"),
        :path => person_cover_photos_settings_path(person),
        :name => "cover_photos"
      },
    ]
  end

end