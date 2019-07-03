require 'active_support/concern'

module HomepageControllerExtension
  extend ActiveSupport::Concern
  
  included do
    skip_before_action :ensure_consent_given
  end

end

