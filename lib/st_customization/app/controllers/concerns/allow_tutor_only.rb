require 'active_support/concern'

module AllowTutorOnly
  extend ActiveSupport::Concern
  include TutorChecker

  included do

    before_action :ensure_user_is_tutor

  end

  # class_methods do

  # end

# private

end

