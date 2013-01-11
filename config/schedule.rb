every :friday, :at => '9pm' do
  rake "alerts:send_student_digests"
end

every :day, :at => '6am' do
  rake "alerts:send_admin_digests"
end
