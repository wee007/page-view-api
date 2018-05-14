class Api::PageViewController < ApplicationController
  include Searchable

  # Fetch sample data from Elasticsearch.
  #
  def index
    @client.cluster.health

    sample_data = PageView.map_sample_data
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

  # Fetch data from Elasticsearch.
  #
  def fetch
    @client.cluster.health

    param_data = PageView.map_param_data params
    before = param_data[:before]
    after = param_data[:after]
    interval = param_data[:interval]

    response = []

    param_data[:urls].each do |url|
      response << search({ page_url: url }, { before: before, after: after }, interval)
    end

    render json: response
  rescue => error
    render json: [{ error: error }]
  end
end
