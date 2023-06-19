class RetroPublicId < ActiveRecord::Migration[7.0]
  def up
    # schemas
    Schema.all.each do |s|
      s.set_public_id # to generate public_id
      s.save
    end
    #
    # services
    Service.all.each do |s|
      s.set_public_id
      s.save
    end
    #
    # teams
    Team.all.each do |t|
      t.set_public_id
      t.update_column(:public_id, t.public_id)
    end
    ##
    ## businesses
    Business.all.each do |b|
      b.set_public_id
      b.save
    end
    ##
    ## users
    User.all.each do |u|
      u.set_public_id
      u.save
    end
  end

  def down
    # delete all public_ids
  end
end
