require '6px'

px = PX.new(
          user_id: '53b5d083a2d7c1d35cbe06bd',
          api_key: 'a5420f5c70504c3de61c8be5c613e124',
          api_secret: '2512cb111fea708222a787d5e77f0722'
        )

images = {golden_gate: 'http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg'}

puts "Sending rotate request\n"
response = px.
            inputs(images).
            output({golden_gate: false}).
              rotate({degrees: 90}).
              tag('rotated').
              url('6px').
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
puts  completed_job['processed']['rotated']['output']['golden_gate']['location']