require 'active_support/concern'

module AllowMemberOnly
  extend ActiveSupport::Concern
  include MemberChecker

  included do

    before_action :ensure_user_is_member

  end

  # class_methods do

  # end

# private

end

