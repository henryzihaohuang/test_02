module ApplicationHelper
  def formatted_duration(duration)
    parts = []

    if duration.parts[:weeks]
      parts << "#{duration.parts[:weeks]} #{"week".pluralize(duration.parts[:weeks])}"
    end

    if duration.parts[:days]
      parts << "#{duration.parts[:days]} #{"day".pluralize(duration.parts[:days])}"
    end

    if duration.parts[:hours]
      parts << "#{duration.parts[:hours]} #{"hour".pluralize(duration.parts[:hours])}"
    end

    if duration.parts[:minutes]
      parts << "#{duration.parts[:minutes]} #{"minute".pluralize(duration.parts[:minutes])}"
    end

    if parts.any?
      parts.join(" ")
    else
      "N/A"
    end
  end

  def date_range_to_human(date_range_filter)
    case date_range_filter
    when "past_week"
      "in the past week"
    when "past_month"
      "in the past month"
    when "year_to_date"
      "year to date"
    end
  end
end
