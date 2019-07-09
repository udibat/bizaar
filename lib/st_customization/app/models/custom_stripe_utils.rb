module CustomStripeUtils

  def self.set_customer_default_source(customer_id, default_source_id)
    sett = StripeService::API::StripeApiWrapper.payment_settings_for(Community.first)
    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    # stripe_acc = cached_stripe_customer || self.get_or_create_stripe_customer_account(user, community)

    Stripe::Customer.update(
      customer_id,
      {
        default_source: default_source_id,
      }
    )
  end


  def self.list_customer_payment_cards(user, community, cached_stripe_customer = nil)
    sett = StripeService::API::StripeApiWrapper.payment_settings_for(community)
    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    stripe_acc = cached_stripe_customer || self.get_or_create_stripe_customer_account(user, community)

    cards =[]
    stripe_acc.sources.auto_paging_each{|r|
      # cards << r if r.object == 'card'

      if r.object == 'card'
        if r.id.to_s == stripe_acc.default_source
          r[:is_default_source] = true
        end

        cards << r
      end

    }

    cards
  end


  def self.create_customer_payment_card(user, community, card_params = {})

    sett = StripeService::API::StripeApiWrapper.payment_settings_for(community)
    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    stripe_acc_id = user.stripe_account.try(:stripe_customer_id)
    unless stripe_acc_id
      stripe_acc = self.get_or_create_stripe_customer_account(user, community)
      stripe_acc_id = stripe_acc.id
    end

    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    token = Stripe::Token.create({
      card: card_params,
    })

    # binding.pry

    Stripe::Customer.create_source(
      stripe_acc_id,
      {
        source: token.id
      }
    )
  end

  def self.delete_customer_oayment_card(user, community, card_id)

    sett = StripeService::API::StripeApiWrapper.payment_settings_for(community)
    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    Stripe::Customer.delete_source(
      user.stripe_account.stripe_customer_id,
      card_id
    )
  end

  # def self.create_customer_payment_card(stripe_customer_acc_id, card_params = {})
  #   Stripe::Customer.create_source(
  #     stripe_customer_acc_id,
  #     {
  #       source: card_params
  #     }
  #   )
  # end

  def self.get_or_create_stripe_customer_account(user, community)

    sett = StripeService::API::StripeApiWrapper.payment_settings_for(community)
    StripeService::API::StripeApiWrapper.configure_payment_for(sett)

    user.create_stripe_account unless user.stripe_account
    stripe_acc = user.stripe_account
    wrp = StripeService::API::Api.wrapper

    # Stripe.api_key = 'sk_test_NPkN0GJk3AsI1rnVDAZrEWeZ'

    if stripe_acc.stripe_customer_id.present?
      wrp.get_customer_account(
        community: community,
        customer_id: stripe_acc.stripe_customer_id
      )

    else
      res = wrp.register_customer(
          community: community,
          email: user.primary_email.address,
          card_token: nil
        )

      stripe_acc.stripe_customer_id = res.id
      stripe_acc.save!

      res
    end

  end

  def self.reset_stripe_keys!
    ps = PaymentSettings.find_by_payment_gateway 'stripe'
    ps.api_private_key = ps.api_publishable_key = ps.api_visible_private_key = nil
    ps.api_verified = false
    ps.save!
  end

end

