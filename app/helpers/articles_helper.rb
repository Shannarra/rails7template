module ArticlesHelper
  def localized_creation_time(article)
    article.created_at.in_time_zone(ENV.try("TIMEZONE", "UTC"))
  end
end
