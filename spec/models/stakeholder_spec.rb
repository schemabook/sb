require 'rails_helper'

RSpec.describe Stakeholder, type: :model do
  it { should validate_uniqueness_of(:schema_id).scoped_to(:user_id) }
end
