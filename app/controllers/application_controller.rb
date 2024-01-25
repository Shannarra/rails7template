# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  USER_ADDITIONAL_ATTRIBUTES = %i[name phone address image]

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: USER_ADDITIONAL_ATTRIBUTES)
    devise_parameter_sanitizer.permit(:account_update, keys: USER_ADDITIONAL_ATTRIBUTES)
  end
end
