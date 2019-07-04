require 'active_support/concern'

module MemberChecker
  extend ActiveSupport::Concern

  # included do

  #   before_action :ensure_user_is_member

  # end

  # class_methods do

  # end

private
  def ensure_user_is_member
    if @current_user.is_tutor?
      flash[:error] = 'You should be a member (not a tutor) to access this page'
      redirect_to login_path
    end
  end

end

