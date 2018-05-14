# Initialize and query the Elasticsearch cluster.
#
module Searchable
  extend ActiveSupport::Concern

  included do
    before_action :initialize
  end

  private

  def initialize
    @client = Elasticsearch::Client.new \
      hosts: [{
        host: ENV['ELASTICSEARCH_HOST'],
        port: ENV['ELASTICSEARCH_PORT'],
        user: ENV['ELASTICSEARCH_USER'],
        password: ENV['ELASTICSEARCH_PASSWORD'],
        scheme: ENV['ELASTICSEARCH_SCHEME']
      }],
      log: true,
      reload_connections: true,
      retry_on_failure: 3
  end

  def search keyword, date_range, interval
    @client.search \
      index: 'events',
      body: {
        query: {
          bool: {
            must: [
              {
                match: keyword
              },
              {
                range: {
                  derived_tstamp: {
                    gte: date_range[:after],
                    lt: date_range[:before]
                  }
                }
              }
            ]
          }
        },
        aggregations: {
          count_over_time: {
            date_histogram: {
              field: 'derived_tstamp',
              format: 'hh:mm',
              interval: interval
            }
          },
          url: {
            terms: {
              field: 'page_url'
            }
          }
        }
      }
  end
end
