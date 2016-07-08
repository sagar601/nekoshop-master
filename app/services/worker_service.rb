class WorkerService

  def do_later job_class, *job_arguments, **wait_time
    job_class.set(**wait_time).perform_later(*job_arguments)
  end

end