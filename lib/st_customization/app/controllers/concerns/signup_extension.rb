require 'active_support/concern'

module SignupExtension
  extend ActiveSupport::Concern

  included do

    # ToDo: refactor this stuff
    alias_method :new_before_redef, :new
    def new

      new_before_redef
    
    end
  end

  # class_methods do

  # end

end
