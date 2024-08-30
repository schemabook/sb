require 'rails_helper'

RSpec.describe Webhook, type: :model do
  it { should belong_to :schema }
  it { should belong_to :user }
  it { should validate_presence_of :url }
end
