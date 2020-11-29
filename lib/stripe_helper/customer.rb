module StripeHelper
  class Customer
    def self.create(customer)
      Stripe::Customer.create({
        email: customer.default_email.email,
        name: customer.full_name,
        metadata: {
          customer_id: customer.id
        }
      })
    end
  
    def self.find_by_email(email)
      Stripe::Customer.list(email: email || "", limit: 1)["data"].first
    end
  
    def self.link_to_customer(stripe_customer, customer)
      return unless stripe_customer && customer
      customer.external_entities.new(
        external_id: stripe_customer.id,
        source: ExternalEntitySource.find_by_name("Stripe")
      ).save!
    end
  end
end