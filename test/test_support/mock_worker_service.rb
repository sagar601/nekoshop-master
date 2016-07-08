class MockWorkerService

  def initialize
    @jobs = []
  end

  def do_later job_class, *job_arguments, **wait_time
    @jobs << Job.new(job_class, wait_time)
  end

  def has_job? job_class, **wait_time
    @jobs.include? Job.new(job_class, wait_time)
  end

  Job = Struct.new :job_class, :wait_time

end