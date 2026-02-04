class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include LogRequest

  def current_user
    # dummy current user before authentication is implemented
    nil
  end
end
