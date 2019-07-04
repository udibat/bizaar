class PaymentCardsWizardController < ApplicationController
  before_action do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_this_page")
  end

  skip_before_action :ensure_consent_given

  include AllowMemberOnly

  def set_default
    stripe_customer_id = @current_user.stripe_account.stripe_customer_id
      
    CustomStripeUtils.set_customer_default_source(stripe_customer_id, params['id'])

    cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)
    
    if cards
      render json: {
        cards: cards.map{|h| h.to_h.slice(:id, :name, :last4, :is_default_source) }
      }, status: 200
    else
      render json: { error: '' }, status: 422
    end
  end

  def index
    cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)
    
    if cards
      render json: {
        cards: cards.map{|h| h.to_h.slice(:id, :name, :last4, :is_default_source) }
      }, status: 200
    else
      render json: { error: '' }, status: 422
    end
  end

  def create
    f_name = params['first_name'].to_s.gsub(/[^a-zA-Z\' ]/, '').humanize
    l_name = params['last_name'].to_s.gsub(/[^a-zA-Z\' ]/, '').humanize

    card_holder_name = "#{f_name} #{l_name}"

    

    card_params = {
      object: 'card',
      number: params['number'],
      exp_month: params['exp_date'].to_s.split('/').first.to_i,
      exp_year: params['exp_date'].to_s.split('/').last.to_i,
      cvc: params['cvc'],
      name: card_holder_name,
    }

    error_message = nil
    payment_card = begin

      CustomStripeUtils.create_customer_payment_card(@current_user, @current_community, card_params)

    rescue Stripe::CardError => e
      error_message = e.message
      false
    rescue => e
      error_message = e.message
      false
    end
    

    if params['make_card_default'] == true &&
          payment_card &&
          @current_user.stripe_account &&
          stripe_customer_id = @current_user.stripe_account.stripe_customer_id
      
        CustomStripeUtils.set_customer_default_source(stripe_customer_id, res.id)

    end


    # binding.pry
    cards = CustomStripeUtils.list_customer_payment_cards(@current_user, @current_community)

    if payment_card && cards
      render json: {
        cards: cards.map{|h| h.to_h.slice(:id, :name, :last4, :is_default_source) }
      }, status: 200
    else
      render json: { error: {card: [error_message]} }, status: 422
    end
  end

  def destroy

  end

end

