every :friday, :at => '9pm' do
  rake "alerts:send_student_digests"
end
