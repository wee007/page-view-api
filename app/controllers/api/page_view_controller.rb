class Api::PageViewController < ApplicationController
  include Searchable

  before_action :sample_data, only: :index

  # Fetch sample data from Elasticsearch.
  #
  def index
    @client.cluster.health

    before = sample_data[:before]
    after = sample_data[:after]
    interval = sample_data[:interval]

    response = []

    sample_data[:urls].each do |url|
      response << search({ page_url: url }, { before: before, after: after }, interval)
    end

    render json: response
  rescue => error
    render json: [{ error: error }]
  end

  private

  def sample_data
    {
      urls: [
        'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615',
        'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'
      ],
      before: Date.parse('2017-06-04').strftime('%Q'), # Convert date to milliseconds
      after: Date.parse('2017-05-31').strftime('%Q'), # Convert date to milliseconds
      interval: '10m'
    }
  end
end
