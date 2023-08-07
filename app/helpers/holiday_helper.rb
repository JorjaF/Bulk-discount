module HolidayHelper
  require "net/http"
  require "json"

  def upcoming_us_holidays(count = 3)
    holidays_data = fetch_upcoming_holidays
    holidays_data.first(count)
  end

  private

  def fetch_upcoming_holidays
    uri = URI("https://date.nager.at/Api/v2/NextPublicHolidaysWorldwide")
    params = { country: "US", comingYears: 1 }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    return [] unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
