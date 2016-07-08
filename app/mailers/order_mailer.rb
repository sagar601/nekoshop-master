class OrderMailer < ApplicationMailer

  def new_order user, order
    @order = order
    @name = user.name

    mail to: user.email, subject: default_i18n_subject(order_id: order.id)
  end

end
