class Validators::CommentValidator < ActiveModel::Validator
  def validate(record)
    return true if record.user.nil?

    return unless record.user.business.schemas.exclude?(record.version.schema)

    record.errors.add :version, "Invalid version id for business' schemas"
  end
end
