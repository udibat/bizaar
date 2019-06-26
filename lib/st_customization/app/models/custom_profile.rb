class CustomProfile < ApplicationRecord

  MAX_DESCRIPTION_LENGTH = 500

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  belongs_to :person, foreign_key: "person_id"
  has_many :certifications, dependent: :destroy
  has_many :cover_photos, dependent: :destroy
  accepts_nested_attributes_for :cover_photos, :allow_destroy => true

  has_many :id_verifications, dependent: :destroy
  accepts_nested_attributes_for :id_verifications, :allow_destroy => true

  validates_length_of :description, maximum: MAX_DESCRIPTION_LENGTH

  after_commit :ensure_primary_photo_set

  def ensure_primary_photo_set
    if cover_photos.where(is_primary_photo: true).count == 0
      cover_photos.where(is_primary_photo: false).limit(1).update(is_primary_photo: true)
    end
  end

end

