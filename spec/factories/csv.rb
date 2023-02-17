module SchemaFormat
  class Csv
    attr_accessor :string

    def to_s
      string
    end
  end
end

FactoryBot.define do
  factory :csv, class: "SchemaFormat::Csv" do
    string { 'foo,bar,baz' }
  end

  trait :with_headers do
    string { 'foo,bar,baz\nfirst_name,last_name,email' }
  end

  trait :with_delimiter do
    string { 'foo;bar;baz' }
  end
end
