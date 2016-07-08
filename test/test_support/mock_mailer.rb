class MockMailer

  def initialize
    @emails = []
  end

  def send_email mailer_class, mailer_method, *args
    @emails << Email.new(mailer_class, mailer_method, args)
  end

  def sent_email? mailer_class, mailer_method, *args
    @emails.include? Email.new(mailer_class, mailer_method, args)
  end

  Email = Struct.new :mailer_class, :mailer_method, :mail_data

end