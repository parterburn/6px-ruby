require '6px'

six_px = SixPX.new(
          user_id: USER_ID,
          api_key: API_KEY,
          api_secret: API_SECRET
        )

images = {golden_gate: 'http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg'}

puts "Sending crop request\n"
response = six_px.
            inputs(images).
            crop({x: 0, y: 0, width: 250, height: 250}).
            rotate({degress: 90}).
            resize({width: 500, height: 500}).
            url('6px').
            refs({golden_gate: false}).
            send

puts "Response:"
puts response
puts "\n"

puts "Waiting for job to process"
completed_job = six_px.jobs(job_id: response["id"])

while completed_job["status"] == "pending"
  print "."
  sleep 1
  completed_job = six_px.jobs(job_id: response["id"])
end

puts "\n\n"
puts "Heres your completed job:"
puts completed_job

puts "\n"
puts "Check out the completed image at the following url:"
puts completed_job["processed"]["null"]["location"]