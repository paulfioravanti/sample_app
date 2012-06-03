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

end
