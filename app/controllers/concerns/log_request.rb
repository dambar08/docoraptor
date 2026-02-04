module LogRequest
  extend ActiveSupport::Concern

  included do
    around_action :log_request
  end

  private

  def log_request
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    yield

  rescue => e
    log_error(e)
    raise
  ensure
    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration = ((finish - start) * 1000).round(1)

    Rails.logger.info(
      "[REQ] " \
      "method=#{request.method} " \
      "path=#{request.fullpath} " \
      "status=#{response.status} " \
      "ms=#{duration} " \
      "ip=#{request.remote_ip} " \
      "user_id=#{current_user&.id}"
    )
  end

  def log_error(e)
    Rails.logger.error(
      "[REQ-ERROR] #{e.class}: #{e.message} " \
      "path=#{request.fullpath}"
    )
  end
end
