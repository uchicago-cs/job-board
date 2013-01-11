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

  desc "Send daily alert digests to admins"
  task :send_admin_digests => :environment do
    new_postings = Posting.all_pending.where("reviewed_by IS NULL")
    new_employers = Employer.where(:approved => false)
    updated_postings = Posting.all_pending.where("reviewed_by IS NOT NULL")
    count = 0
    Student.admins.where(:digests => true).each do |admin|
      postings_array = []
      employers_array = []
      updated_array = []

      new_postings.each do |posting|
        postings_array << posting if admin.alert_on_new_posting && posting.pending? && posting.reviewer.nil?
      end

      new_employers.each do |employer|
        employers_array << employer if admin.alert_on_new_employer && !employer.approved
      end

      updated_postings.each do |posting|
        updated_array << posting if (admin.alert_on_updated_posting || (admin.alert_on_my_updated_posting && posting.reviewer == admin)) && posting.pending?
      end

      unless postings_array.empty? && employers_array.empty? && updated_array.empty?
        Notifier.admin_alert_digest(admin, postings_array, employers_array, updated_array).deliver
        count += 1
      end
    end
    puts "Digests sent to #{count} #{count == 1 ? "admin" : "admins"}."
  end
end
