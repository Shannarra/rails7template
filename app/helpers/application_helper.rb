# frozen_string_literal: true

module ApplicationHelper
  def application_timezone
    ENV.try(:[], "TIMEZONE") || "UTC"
  end
  
  def localized_creation_time(article)
    article.created_at.in_time_zone(application_timezone)
  end
end
