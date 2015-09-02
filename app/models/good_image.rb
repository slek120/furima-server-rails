class GoodImage < ActiveRecord::Base
  attr_accessor :good_id, :image, :index
  belongs_to :good, touch: true
  mount_uploader :image, GoodUploader
end