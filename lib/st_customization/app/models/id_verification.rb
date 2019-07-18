class IdVerification < ApplicationRecord
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/,
    message: "Sorry, we cannot accept that file. Please upload serviceable jpeg, png picture."
  validates_presence_of :image

  belongs_to :custom_profile

  after_commit :update_cutom_profile_badge

  enum status: [
    :pending,
    :approved,
    :rejected
  ], _prefix: true

  def update_cutom_profile_badge
    return if custom_profile.destroyed?
    custom_profile.update_column(:id_verified, custom_profile.id_verifications.status_approved.exists?)
  end

end

