class CertificationWizardDecorator < Draper::Decorator
  decorates :certification
  
  delegate_all

  def category_name
    if cat = object.category
      translation = cat.translations.where(locale: I18n.locale).first
      translation ||= cat.translations.first
      translation.name if translation
    end
  end

  def image_thumb_url
    attachment_thumb_url
  end

  def as_json(options = {})
    object.as_json({
      only: [:id, :name]
    }.merge(options)).merge({
      category_name: category_name,
      image_thumb_url: image_thumb_url
    })
  end

end

