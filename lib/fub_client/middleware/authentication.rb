module FubClient
  module Middleware
    class Authentication < Faraday::Middleware
      def call(env)
        env[:request_headers]["Authorization"] = "Basic " + 
          Base64.strict_encode64("#{FubClient::Client.instance.api_key}:")
        if FubClient::Client.instance.x_system.present?
          env[:request_headers]["X-System"] = FubClient::Client.instance.x_system
        end
        if FubClient::Client.instance.x_system_key.present?
          env[:request_headers]["X-System-Key"] = FubClient::Client.instance.x_system_key
        end
        @app.call(env)
      end
    end
  end
end
