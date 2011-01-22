Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :resolution do |resolution|
  resolution.title        "Test resolution"
  resolution.start_date   Date.today + 1
  resolution.repetitions  3
  resolution.period       'week'
  resolution.association  :user
  resolution.unit         'hours'
  resolution.times        3
end

Factory.define :resolution_result do |resolution_result|
  resolution_result.times_completed   0
  resolution_result.start_date        Date.today + 1
  resolution_result.end_date          Date.today + 8
end

