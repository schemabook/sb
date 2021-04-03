require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to :business }
  it { should accept_nested_attributes_for :business }
  it { should validate_presence_of :email }
end
