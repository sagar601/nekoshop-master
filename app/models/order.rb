class Order < ActiveRecord::Base
  include IsAddressable

  belongs_to :customer, inverse_of: :orders
  has_many :items, dependent: :destroy, class_name: 'OrderItem', inverse_of: :order

  monetize :shipping_cost_cents, as: 'shipping_cost'
  monetize :total_cents, as: 'total'

  def free?
    total.zero?
  end

  def pay charge_id = nil
    raise ChargeRequiredError if !free? && charge_id.nil?

    state.trigger :pay
    self.charge_id = charge_id
  end

  def paid?
    state.state == :paid
  end

  def cancel
    state.trigger :cancel
  end

  def cancelled?
    state.state == :cancelled
  end

  def summary
    [
      "#{self.class.model_name.human} ##{id}",
      items.map(&:summary),
      "#{self.class.human_attribute_name :shipping_cost}: #{shipping_cost.format}",
      "#{self.class.human_attribute_name :total}: #{total.format}",
    ].flatten!.join "\n"
  end

  private

  def state
    @state ||= begin
      fsm = MicroMachine.new(super.to_sym || :created)

      fsm.when :pay, :created => :paid
      fsm.when :cancel, :created => :cancelled, :paid => :cancelled

      fsm.on(:any) { self.state = @state.state }
      fsm
    end
  end

  protected

  def state= state
    super state
  end

  class ChargeRequiredError < RuntimeError; end
end