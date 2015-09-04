# == Schema Information
#
# Table name: good_images
#
#  id         :integer          not null, primary key
#  good_id    :integer
#  image      :string(255)
#  index      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GoodImage < ActiveRecord::Base
  belongs_to :good, touch: true
  mount_uploader :image, GoodUploader
end
