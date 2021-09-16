require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to :business }
  it { should belong_to :team }

  it { should accept_nested_attributes_for :business }

  it { should validate_presence_of :email }
  it { should validate_presence_of :business }
  it { should validate_presence_of :team }
end
