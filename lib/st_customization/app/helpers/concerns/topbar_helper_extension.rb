require 'active_support/concern'

module TopbarHelperExtension
  extend ActiveSupport::Concern

  included do

    class <<self

      alias_method :topbar_props_before_redef, :topbar_props
      def topbar_props(community:, path_after_locale_change:, user: nil, search_placeholder: nil,
                    locale_param: nil, current_path: nil, landing_page: false, host_with_port:)
        original_props = topbar_props_before_redef(
          community: community,
          path_after_locale_change: path_after_locale_change,
          user: user,
          search_placeholder: search_placeholder,
          locale_param: locale_param,
          current_path: current_path,
          landing_page: landing_page,
          host_with_port: host_with_port)

        # add some custom user fields
        original_props[:user].merge!(build_user_react_fields(user))

        # disable newListingButton for members (not tutors)
        unless (user.present? && user.is_tutor?)
          original_props[:newListingButton] = nil
        end

        original_props

      end

      def build_user_react_fields(user)
        res = {}
        res[:userType] = (user.present? && user.is_tutor?) ? 'tutor' : 'member'
        res
      end

    end
    

  end

end

