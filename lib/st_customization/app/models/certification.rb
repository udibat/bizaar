class Certification < ApplicationRecord

  has_attached_file :image, styles: lambda {|a|
    a.instance.attachment_is_image? ? {medium: "300x300>", thumb: "100x100>"} : {}
  }, default_url: lambda {|a|
    if a.instance.attachment_is_pdf?
      "/images/pdf_icon.png"
    else
      "/images/:style/missing.png"
    end
  }

  after_commit :update_cutom_profile_badge

  enum status: [
    :pending,
    :approved,
    :rejected
  ], _prefix: true

  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf']

  belongs_to :custom_profile
  belongs_to :category

  validates_presence_of :name, :category


  def update_cutom_profile_badge
    return if custom_profile.destroyed?
    custom_profile.update_column(:cert_verified, custom_profile.certifications.status_approved.exists?)
  end

  def attachment_thumb_url
    if attachment_is_pdf?
      '/images/pdf_icon.png'
    else
      image.url(:thumb)
    end
  end
  
  def attachment_is_image?
    return false unless image.content_type
    image.content_type.match(/^image\/.*/).present?
  end

  def attachment_is_pdf?
    return false unless image.content_type
    image.content_type.to_s == 'application/pdf'
  end

end

