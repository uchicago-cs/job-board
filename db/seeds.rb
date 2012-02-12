# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

employer1 = Employer.create(login: 'j',
                        password: 'jjjjjj',
                        password_confirmation: 'jjjjjj',
                        email: 'jesse@iloverails.com',
                        firstname: 'jesse',
                        lastname: 'ruby',
                        url: 'www.bing.com',
                        affiliation: 'Google',
                        Full_Time: false,
                        Part_Time: false,
                        Internship: false)



employer2 = Employer.create(login: 'js',
                        password: 'jsjsjs',
                        password_confirmation: 'jsjsjs',
                        email: 'jsmith@myface.org',
                        firstname: 'Jane',
                        lastname: 'Smith',
                        url: 'www.myface.com',
                        affiliation: 'Myface',
                        Full_Time: false,
                        Part_Time: false,
                        Internship: false)

employer3 = Employer.create(login: 'bs',
                        password: 'bsbsbs',
                        password_confirmation: 'bsbsbs',
                        email: 'uchi@borja.org',
                        firstname: 'John',
                        lastname: 'Doe',
                        url: 'www.ryersonhasafourthfloor.com',
                        affiliation: 'The 4th Floor',
                        Full_Time: false,
                        Part_Time: false,
                        Internship: false)
           
JobSeeker.create(login: 'test',
                 password: 'password',
                 password_confirmation: 'password', 
                 email: 'test@example.com',
                 firstname: 'Kevin',
                 lastname: 'Wang',
                 Full_Time: true,
                 Part_Time: true,
                 Internship: true)

Administrator.create(login: 'margaret',
                 password: 'password',
                 password_confirmation: 'password', 
                 email: 'margaret@cs.uchicago.edu',
                 firstname: 'Margaret',
                 lastname: 'Jaffey',
                 Full_Time: false,
                 Part_Time: false,
                 Internship: false)

job1 = JobPosting.create(title: 'Senior Developer',
                  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vulputate, velit eu aliquam commodo, eros est ultricies ligula, sit amet aliquet nisl neque non nisi.',
                  comments: 'Admin comments go here',
                  jobtype: 'Full Time',
                  contact: 'larry@google.com',
                  deadline: Date.new(2000,1,1),
                  state: 'Approved',
                  employer_id: employer1.id,
                  url: 'www.google.com/paradise',
                  affiliation: 'Google')

job2 = JobPosting.create(title: 'Junior Developer',
                  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vulputate, velit eu aliquam commodo, eros est ultricies ligula, sit amet aliquet nisl neque non nisi.',
                  jobtype: 'Part Time',
                  contact: 'jerry@facebook.com',
                  deadline: Date.new(1500,2,2),
                  state: 'Pending Approval',
                  employer_id: employer2.id,
                  url: 'www.facebook.com/notreal',
                  affiliation: 'Facebook')

job3 = JobPosting.create(title: 'Despised Intern',
                  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vulputate, velit eu aliquam commodo, eros est ultricies ligula, sit amet aliquet nisl neque non nisi.',
                  comments: 'Admin comments go here',
                  jobtype: 'Internship',
                  contact: 'uchicago@borja.gov',
                  deadline: Date.new(1066,3,3),
                  state: 'Approved',
                  employer_id: employer3.id,
                  url: 'www.borjasarmy.gov',
                  affiliation: 'Individual')

tag1 = Tag.create(name: 'Ruby',
           tagtype: 'language')

tag2 = Tag.create(name: 'Python',
           tagtype: 'language')

tag3 = Tag.create(name: 'Java',
           tagtype: 'language')

job1.tags << tag1
job1.tags << tag2
job2.tags << tag3
job3.tags << tag2
