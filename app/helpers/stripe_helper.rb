module StripeHelper

  def load_stripe
    content_for :javascripts do
      javascript_include_tag('https://js.stripe.com/v2/') +
      javascript_tag("Stripe.setPublishableKey('#{ ENV.fetch('STRIPE_PUBLIC_KEY') }');")
    end
  end

end