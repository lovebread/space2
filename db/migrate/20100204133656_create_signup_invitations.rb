class CreateSignupInvitations < ActiveRecord::Migration
  def self.up
    create_table :signup_invitations do |t|
      t.integer :sender_id
      t.string :recipient_email
      t.string :token
      t.timestamps
    end
  end

  def self.down
    drop_table :signup_invitations
  end
end
