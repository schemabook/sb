require 'rails_helper'

RSpec.describe Business, type: :model do
  subject { described_class.new(name: 'example') }

  it { should have_many :users }
  it { should have_many :teams }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
end
