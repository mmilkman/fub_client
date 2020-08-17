module FubClient
  class Client
    API_URL = 'api.followupboss.com'
    API_VERSION = 'v1'

    include Singleton

    attr_writer :api_key
    attr_reader :her_api
    attr_accessor :x_system
    attr_accessor :x_system_key

    def initialize
      init_her_api
    end

    def api_key
      @api_key ||= ENV['FUB_API_KEY']
    end

    def api_uri
      @api_uri ||= URI::HTTPS.build(host: API_URL, path: "/#{API_VERSION}")
    end

    def validate_api_key!
      connection = Faraday.new(api_uri)
      connection.basic_auth(api_key, '')
      response = connection.get("/#{API_VERSION}/people?limit=1")
      return true if response.status == 200

      raise InvalidAuthorization, "api key: '#{api_key}' is invalid. Response: '#{response.body}'"
    end

    private

    def init_her_api
      @her_api = Her::API.new
      @her_api.setup url: self.api_uri.to_s do |c|
        # Request
        c.use FubClient::Middleware::Authentication
        c.use Faraday::Request::UrlEncoded

        # Response
        c.use FubClient::Middleware::Parser

        # Adapter
        c.use Faraday::Adapter::NetHttp
      end
    end

    class InvalidAuthorization < StandardError; end
  end
end
