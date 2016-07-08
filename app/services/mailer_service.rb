class MailerService

  def send_email mailer_class, mailer_method, *args
    mailer_class.__send__(mailer_method, *args).deliver_later
  end

end