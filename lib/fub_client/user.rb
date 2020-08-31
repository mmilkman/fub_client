module FubClient
  class User < Resource
    def self.me
      resource_path("me")
      find(1)
    end
  end
end
