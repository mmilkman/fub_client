module FubClient
  module Middleware
    class RequestCleanup < Faraday::Middleware
      def call(env)
        # Remove id from request body since it produces error on FUB API side
        if env[:body].present?
          env[:body].delete(:id)
        end
        @app.call(env)
      end
    end
  end
end
