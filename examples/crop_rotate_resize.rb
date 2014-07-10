require '6px'

px = PX.new(
          user_id: 'USER_ID',
          api_key: 'API_KEY',
          api_secret: 'API_SECRET'
        )

images = {golden_gate: 'http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg'}

puts "Sending crop request\n"
response = px.
            inputs(images).
            output({golden_gate: false}).
              crop({x: 0, y: 0, width: 1000, height: 1000}).
              rotate({degrees: 90}).
              resize({width: 500, height: 500}).
              url('6px').
              tag('cropped_rotated_resize_image').
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
p completed_job['processed']['cropped_rotated_resize_image']['output']['golden_gate']['location']
