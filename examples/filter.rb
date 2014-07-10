require '6px'

px = PX.new(
          user_id: 'USER_ID',
          api_key: 'API_KEY',
          api_secret: 'API_SECRET'
        )

images = {golden_gate: 'http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg'}

puts "Sending filter request\n"
response = px.
            inputs(images).
            output({golden_gate: false}).
              filter({sepia: 80, contrast: 60}).
              url('6px').
              tag('filtered').
            save

puts "Response:"
puts response
puts "\n"

puts "Waiting for job to process"
completed_job = px.jobs(job_id: response["id"])

while completed_job["status"] == "pending"
  print "."
  sleep 1
  completed_job = px.jobs(job_id: response["id"])
end

puts "\n\n"
puts "Heres your completed job:"
puts completed_job

puts "\n"
puts "Check out the completed image at the following url:"
p completed_job['processed']['filtered']['output']['golden_gate']['location']
