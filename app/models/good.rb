# == Schema Information
#
# Table name: goods
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :string(255)
#  price      :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  expired_at :datetime
#  user_id    :integer
#

class Good < ActiveRecord::Base
  belongs_to :user
  has_many :good_images
  accepts_nested_attributes_for :good_images
end
