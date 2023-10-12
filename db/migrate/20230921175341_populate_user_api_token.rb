class PopulateUserAPIToken < ActiveRecord::Migration[7.0]
  def change
    User.all.each do |user|
      user.generate_api_token
      user.save
    end
  end
end
