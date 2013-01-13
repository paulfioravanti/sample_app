# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#

#  content    :string          in translations table

class Micropost < ActiveRecord::Base

  attr_accessible :content
  translates :content
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'created_at DESC'

  def self.from_users_actively_followed_by(user)
    followed_users = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user"
    # When Rails Brakeman service upgrades to 1.9.0, this
    # code can be swapped in for the above
    # followed_users = Relationship.users_actively_followed_by(user).to_sql
    where("user_id IN (#{followed_users}) OR user_id = :user",
          user: user)
  end

  def self.paginate_eagerly(page)
    paginate(include: [:user, :translations], page: page)
  end

end
