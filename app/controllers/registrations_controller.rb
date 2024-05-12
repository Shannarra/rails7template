class RegistrationsController < Devise::RegistrationsController
  before_action :disable_registration!, only: %i[new create]

  def new
  end

  def create
  end

  def update
    super
  end

  private
  def disable_registration!
    redirect_to new_user_session_path, notice: 'Registrations are disabled. Please log in with your institution provided credentials.'
  end
end
