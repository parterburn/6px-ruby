require '6px'

px = PX.new(
          user_id: USER_ID,
          api_key: API_KEY,
          api_secret: API_SECRET
        )

images = {car: './images/car.jpg'}

puts "Sending crop request\n"
response = px.
            inputs(images).
            output({car: false}).
              crop({x: 0, y: 0, width: 250, height: 250}).
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
puts completed_job["processed"]["null"]["location"]
