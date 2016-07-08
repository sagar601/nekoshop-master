require 'test_helper'

describe MailerService do

  it 'sends emails' do
    dummy_mailer = Struct.new :data, :sent do
      def dummy_email data
        self.data = data
        self
      end

      def deliver_later
        self.sent = true
      end
    end.new

    dummy_data = Object.new

    MailerService.new.send_email dummy_mailer, :dummy_email, dummy_data

    dummy_mailer.sent.must_equal true
    dummy_mailer.data.must_equal dummy_data
  end

end