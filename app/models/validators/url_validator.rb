class Validators::UrlValidator < ActiveModel::Validator
  def validate(record)
    uri = URI.parse(record.url)
    return true if uri.is_a?(URI::HTTP) && uri.host.present?
    return true if uri.is_a?(URI::HTTPS) && uri.host.present?

    record.errors.add :url, "Invalid url for webhook"
  rescue URI::InvalidURIError
    record.errors.add :url, "Invalid url for webhook"
  end
end
