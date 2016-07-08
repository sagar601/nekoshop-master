require 'test_helper'

describe WorkerService do

  it 'schedules jobs' do
    dummy_job = Struct.new :arguments, :wait_time do
      def set **wait_time
        self.wait_time = wait_time
        self
      end
      def perform_later *arguments
        self.arguments = arguments
        self
      end
    end.new

    WorkerService.new.do_later dummy_job, 123, 'abc', wait: 5.minutes

    dummy_job.arguments.must_equal [123, 'abc']
    dummy_job.wait_time.must_equal(wait: 5.minutes)
  end

end