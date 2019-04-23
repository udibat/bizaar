class ChangeKeyEncript < ActiveRecord::Migration[5.1]
  def up
    PaymentSettings.where(payment_gateway: 'stripe').update_all(key_encryption_padding: 1)
  end

  def down
    PaymentSettings.where(payment_gateway: 'stripe').update_all(key_encryption_padding: 0)
  end
end
