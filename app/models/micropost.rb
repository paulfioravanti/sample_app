# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

#  content    :string          in translations table

class Micropost < ActiveRecord::Base

  attr_accessible :content
  translates :content
  belongs_to :user

  default_scope order: 'microposts.created_at DESC'

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)

    # This preferred code brings up a high warning of an SQL injection in
    # Brakeman 1.7.0, so it will remain commented out until the issue is
    # resolved.
    #
    # followed_user_ids = Relationship.select(:followed_id).
    #                     where("follower_id = :user_id").
    #                     to_sql
    # where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
    #       user_id: user.id)
  end

end
