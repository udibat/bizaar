require 'active_support/concern'

module TestimonialsControllerExtension
  extend ActiveSupport::Concern
  

  def categorized_testimonials
    username = params[:person_id]
    target_user = Person.find_by!(username: username, community_id: @current_community.id)

    if request.xhr?
      @testimonials = target_user.categorized_testimonials(@current_community).paginate(:per_page => params[:per_page], :page => params[:page])
      limit = params[:per_page].to_i
      render :partial => "people/testimonials", :locals => {:received_testimonials => @testimonials, :limit => limit}
    else
      redirect_to person_path(target_user)
    end
  end

  included do
    skip_before_action :ensure_authorized_to_give_feedback, only: [:index, :categorized_testimonials]
    skip_before_action :ensure_feedback_not_given, only: [:index, :categorized_testimonials]
  end

end

