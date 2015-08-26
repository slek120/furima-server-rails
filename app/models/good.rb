# == Schema Information
#
# Table name: goods
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :string(255)
#  price      :decimal(10, )
#  expired_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Good < ActiveRecord::Base
end
