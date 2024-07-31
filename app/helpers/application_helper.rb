module ApplicationHelper
  def application_timezone
    ENV.try(:fetch, 'TIMEZONE', 'UTC')
  end

  def localized_creation_time(object)
    object.created_at.in_time_zone(application_timezone)
  end
end
