module Public
  # https://myapp.com/public/health_checks/
  class HealthChecksController < ApplicationPublicController
    def index
      render plain: all_checks? ? 'OK' : 'DOWN'
    end

    private

    def all_checks?
      [].tap do |array|
        # array << redis_connection
        array << database_connection
      end.all?
    end

    # def redis_connection
    #   redis = Redis.new
    #   redis.ping == 'PONG' rescue false
    # end

    def database_connection
      # database connection is not permanent?
      # ApplicationRecord.connected?
      User.count > 0
    rescue StandardError
      false
    end
  end
end
