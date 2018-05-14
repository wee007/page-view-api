class PageView
  include ActiveModel::Model

  class << self
    def map_sample_data
      {
        urls: [
          "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615",
          "http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html"
        ],
        before: Date.parse("2017-06-04").strftime("%Q"), # Convert date to milliseconds
        after: Date.parse("2017-05-31").strftime("%Q"), # Convert date to milliseconds
        interval: "10m"
      }
    end

    def map_param_data params
      {
        urls: params[:url].strip.split(","),
        before: Date.parse(params[:before]).strftime("%Q"), # Convert date to milliseconds
        after: Date.parse(params[:after]).strftime("%Q"), # Convert date to milliseconds
        interval: params[:interval]
      }
    end
  end
end
