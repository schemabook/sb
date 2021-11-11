require 'rails_helper'

RSpec.describe Format, type: :model do
  it { should validate_presence_of :file_type }

  describe "before_save" do
    it "persists the name and file_type" do
      format = create(:format, file_type: :json)

      expect(format.name).to eq("json")
      expect(format.file_type).to eq("json")
    end
  end
end
