require 'minitest/autorun'

require_relative 'mock_worker_service'

describe MockWorkerService do

  it 'pretends to schedule jobs' do
    MockWorkerService.new.must_respond_to :do_later
  end

  it 'remembers the scheduled jobs' do
    job_class = Class.new
    scheduler = MockWorkerService.new
    scheduler.do_later job_class, wait: 5.minutes

    scheduler.has_job?(job_class, wait: 5.minutes).must_equal true

    other_job_class = Class.new
    scheduler.has_job?(other_job_class, wait: 5.minutes).must_equal false
    scheduler.has_job?(job_class, wait: 10.minutes).must_equal false
  end

end