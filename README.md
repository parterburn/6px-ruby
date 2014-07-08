Ruby Wrapper for 6px API
======================================

### Setup

To install this gem on your system, run:

`gem install six_px`

If you want to add this gem to a rails app, then add the following line to your Gemfile:

`gem 'six_px'`

## Authenticating

To get a 6px authenticated connection do the following:

<pre><code>require 'six_px'

six_px = SixPX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)
</code></pre>

This will return an object that will include the correct authorization params for all the following queries

## Jobs

To find an individual job: `job = six_px.jobs(job_id: '53b5d083a2d7c1d35cbe06bd')`

To list all jobs: `jobs = six_px.jobs`

### Pagination

To paginate the returned json you can do the following:

<pre><code># This will return the second page of jobs with the default amount per page of 10.
jobs = six_px.jobs(page: 2)

# This will return the second page of jobs with 100 jobs per page
jobs = six_px.jobs(page: 2, per_page: 100)
</code></pre>

### Sorting

The following commands will allow you to sort your results by a certain value

<pre><code># Sort by value
jobs = six_px.jobs(sort_by: 'created')

# Sort by value (descending)
jobs = six_px.jobs(sort_by: 'created,desc')

# Sort by value (descending)
jobs = six_px.jobs(sort_by: 'created,asc')
</code></pre>

### Search

Search is similar to the ones above. Just add params onto the job method:

#### Number Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#number)

In order to get deeper params, use the " _ " instead of the "."" when entering the params. For example, 'processed_bytes' will be the same thing as 'processed.bytes' in an api call (example below).

<pre><code># This query will return all jobs that processed more than 1048576 bytes:
jobs = six_px.jobs(processed_bytes: '{gt}1048576')
</code></pre>

#### String Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#string)

<pre><code># This query will return all jobs that did not fail:
jobs = six_px.jobs(status: '{not}failed')
</code></pre>

#### Location Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#location)

<pre><code># This query will return all jobs that were near the longitude and latitude of [0.0176,-105.2797]:
jobs = six_px.jobs(processed_images_latlon: '{near}40.0176,-105.2797')
</code></pre>

#### Date Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#dates)

<pre><code># This query will return all the jobs created after right now:

# Need to convert the time to iso8601
formatted_time = Time.new.iso8601
jobs = six_px.jobs(created: "{gt}#{fomatted_time}")
</code></pre>

#### Chain Up Params

These commands can also be input with the pagination and sorting params like so:

<pre><code>formatted_time = Time.new.iso8601
jobs = six_px.jobs(page: 1, per_page: 50, sort_by: 'status', status: '{not}failed', created: "{gt}#{fomatted_time}")`
</code></pre>

## Methods

### Stucture of submitting a job to process images

#### Resizing one image
<pre><code>
# Initialize SixPX authenticated object
six_px = SixPX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)

# Setup images to be processed
images =  {snowboarding: 'URL_TO_IMG'}

# The authenticated object
# Add the hash of the image you want to add
# Rotate the image 90 degress
# The output url - 6px will put it on their hosting platform
# Tells 6px to process the 'snowboarding' image and rename it 'sideways_snowboarding'
# Submit the job to 6px

six_px.
  inputs(images).
  rotate({degrees: 90}).
  url('6px').
  refs({snowboarding: 'sideways_snowboarding'}).
  send
</code></pre>

#### Resizing five images
<pre><code>
# Initialize SixPX authenticated object
six_px = SixPX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)

# Setup images to be processed
images =  {
  img1: 'URL_TO_IMG1',
  img2: 'URL_TO_IMG2',
  img3: 'URL_TO_IMG3',
  img4: 'URL_TO_IMG4',
  img5: 'URL_TO_IMG5'
}

# Setup outputs name mapping
outputs = {
  img1: 'processed_img1,
  img2: 'processed_img2,
  img3: 'processed_img3,
  img4: 'processed_img4,
  img5: 'processed_img5
}

# The authenticated object
# Add the hash of the images you want to add
# Rotate the images 90 degress
# The output url - 6px will put it on their hosting platform
# Tells 6px to process the all five images
# Submit the job to 6px

six_px.
  inputs(images).
  rotate({degrees: 90}).
  url('6px').
  refs(outputs).
  send
</code></pre>

All the available methods are listed: [here](https://github.com/6px-io/6px-api-docs#methods)

These methods can also be chained!

#### Rotate
<pre><code>six_px.
  inputs(images).
  rotate({degrees: 90}).
  url('6px').
  refs(outputs).
  send
</code></pre>

#### Resize
<pre><code>six_px.
  inputs(images).
  resize({height: 400, width: 400}).
  url('6px').
  refs(outputs).
  send
</code></pre>

#### Crop
<pre><code>six_px.
  inputs(images).
  crop({height: 400, width: 400, x: 0, y: 0}).
  url('6px').
  refs(outputs).
  send
</code></pre>

#### Filter
<pre><code>six_px.
  inputs(images).
  filter({sepia: 70, gama: 45}).
  url('6px').
  refs(outputs).
  send
</code></pre>

#### Layer
<pre><code>inputs =  {
  img1: 'URL_TO_IMG1',
  img2: 'URL_TO_IMG2'
}

six_px.
  inputs(images).
  layer({x: 0, y: 0, opacity: 0.5, ref: 'img2'}).
  url('6px').
  refs(outputs).
  send
</code></pre>

#### Analyze
<pre><code>six_px.
  inputs(images).
  analyze({type: 'color', context: 'palette'}).
  url('6px').
  refs({golden_gate: false}).
  send
</code></pre>

#### Chain up multiple!
<pre><code>six_px.
  inputs(images).
  rotate({degrees: 90}).
  resize({height: 400, width: 400}).
  crop({height: 400, width: 400, x: 0, y: 0}).
  filter({sepia: 70, gama: 45}).
  url('6px').
  refs({golden_gate: false}).
  send
</code></pre>

# NEED TO DO
 * Learn more about the data object
 * Learn more about the callback call

