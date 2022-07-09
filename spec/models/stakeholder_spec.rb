require 'rails_helper'

RSpec.describe Stakeholder, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :schema_id }
end
