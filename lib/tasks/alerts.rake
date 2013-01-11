namespace :alerts do
  desc "Send weekly alert digests to students"
  task :send_student_digests => :environment do
    new_postings = Posting.where("updated_at > ?", DateTime.now - 1.week)
    count = 0
    Student.where(:digests => true).each do |student|
      unless student.is_admin?
        postings = []
        new_postings.each do |posting|
          if posting.approved? && student.is_interested_in?(posting)
            postings << posting
          end
        end
        
        unless postings.empty?
          Notifier.student_alert_digest(student, postings).deliver
          count += 1
        end
      end
    end
    puts "Digests sent to #{count} #{count == 1 ? "student" : "students"}."
  end
end
