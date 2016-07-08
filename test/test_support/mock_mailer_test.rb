require 'minitest/autorun'

require_relative 'mock_mailer'

describe MockMailer do

  it 'imitates a MailerService' do
    MailerService.instance_methods.each{ |method| MockMailer.new.must_respond_to method }
  end

  it 'remembers the emails sent' do
    mailer_class = Class.new
    mailer_method = :dummy_email
    mail_data = Object.new
    mailer = MockMailer.new

    mailer.sent_email?(mailer_class, mailer_method, mail_data).must_equal false

    mailer.send_email mailer_class, mailer_method, mail_data

    mailer.sent_email?(mailer_class, mailer_method, mail_data).must_equal true

    other_mailer_class = Class.new
    other_mailer_method = :dummy_email_2
    other_mail_data = Object.new

    mailer.send_email other_mailer_class, other_mailer_method, other_mail_data

    mailer.sent_email?(other_mailer_class, other_mailer_method, other_mail_data).must_equal true
    mailer.sent_email?(mailer_class, mailer_method, mail_data).must_equal true # make sure it doesn't forget the old one
  end

end