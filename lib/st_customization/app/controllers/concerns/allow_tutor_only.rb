require 'active_support/concern'

module AllowTutorOnly
  extend ActiveSupport::Concern

  included do

    before_action :ensure_user_is_tutor

  end

  # class_methods do

  # end

private
  def ensure_user_is_tutor
    unless @current_user.is_tutor?
      flash[:error] = 'You should be a tutor to access this page'
      redirect_to login_path
    end
  end

end

