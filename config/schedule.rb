job_type :rake, "cd :path && RAILS_ENV=:environment /usr/local/bin/bundle exec rake :task --silent :output"

every :friday, :at => '9pm' do
  rake "alerts:send_student_digests"
end

every :day, :at => '6am' do
  rake "alerts:send_admin_digests"
end
