require 'rails_helper'

RSpec.describe Api::PageViewController, type: :controller do
  describe "GET #index" do
    before(:each) do
      get :index
      @response_body = MultiJson.load(response.body)[0]
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns correct hash keys" do
      expect(@response_body.keys).to eql(["took", "timed_out", "_shards", "hits", "aggregations"])
      expect(@response_body["aggregations"].keys).to eql(["count_over_time", "url"])
    end

    context "when retrieving aggregations count over time data" do
      it "returns correct values" do
        expect(@response_body.dig("aggregations", "count_over_time", "buckets")[0]["key_as_string"]).to eql("05:30")
        expect(@response_body.dig("aggregations", "count_over_time", "buckets")[0]["doc_count"]).to eql(1)
      end
    end

    context "when retrieving aggregations url data" do
      it "returns correct values" do
        expect(@response_body.dig("aggregations", "url", "buckets")[0]["key"]).to eql("http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615")
        expect(@response_body.dig("aggregations", "url", "buckets")[0]["doc_count"]).to eql(148530)
      end
    end
  end

  describe "POST #fetch" do
    context "when all param values are passed" do
      before(:each) do
        post :fetch,
          params: {
            url: "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615,
            http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html",
            before: "2017-06-04",
            after: "2017-05-31",
            interval: "10m"
          }

        @response_body = MultiJson.load(response.body)[0]
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns correct hash keys" do
        expect(@response_body.keys).to eql(["took", "timed_out", "_shards", "hits", "aggregations"])
        expect(@response_body["aggregations"].keys).to eql(["count_over_time", "url"])
      end

      context "when retrieving aggregations count over time data" do
        it "returns correct values" do
          expect(@response_body.dig("aggregations", "count_over_time", "buckets")[0]["key_as_string"]).to eql("05:30")
          expect(@response_body.dig("aggregations", "count_over_time", "buckets")[0]["doc_count"]).to eql(1)
        end
      end

      context "when retrieving aggregations url data" do
        it "returns correct values" do
          expect(@response_body.dig("aggregations", "url", "buckets")[0]["key"]).to eql("http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615")
          expect(@response_body.dig("aggregations", "url", "buckets")[0]["doc_count"]).to eql(148530)
        end
      end
    end

    context "when not all param values are passed" do
      it "returns an error" do
        post :fetch,
          params: {
            url: "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615"
          }

        expect(MultiJson.load(response.body)[0].keys).to eql(["error"])
      end
    end
  end
end
