class Validators::SchemaValidator < ActiveModel::Validator
  def validate(record)
    return false if record.user.nil?

    return true unless record.user.business.schemas.exclude?(record.schema)

    record.errors.add :version, "Invalid schema id for business' schemas"
  end
end
