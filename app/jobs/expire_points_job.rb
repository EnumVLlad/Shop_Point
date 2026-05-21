class ExpirePointsJob < ApplicationJob
  self.queue_adapter = :sidekiq
  queue_as :default

  def perform
    Loyalty::ExpirePoints.call
  end
end
