class ApplicationMailer < ActionMailer::Base
  default from: "nekoshop@example.com"
  layout 'mailer'

  # TODO add an easily accessible data object with stuff like email signature
  # and a default `from` email address pulled from config (and possibly from ENV)
end
