# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do |i|
  Good.create(title: ('Good #'+i.to_s), body: ('This is good #'+i.to_s), price: '0', expired_at: (Time.now + 60*60*24*365))
end