require 'rails_helper'

RSpec.describe Schema, type: :model do
  it { should belong_to :team }
end
