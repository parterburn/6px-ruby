Ruby gem for 6px
====================

### Requirements

* Ruby Version: =< 1.9.3

### Setup

To install this gem on your system, run:

`gem install 6px`

If you want to add this gem to a rails app, then add the following line to your Gemfile:

`gem '6px'`

## Authenticating

To get a 6px authenticated connection do the following:

<pre><code>require '6px'

px = PX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)
</code></pre>

This will return an object that will include the correct authorization params for all the following queries

## Jobs

To find an individual job: `job = px.jobs(job_id: '53b5d083a2d7c1d35cbe06bd')`

To list all jobs: `jobs = px.jobs`

### Pagination

To paginate the returned JSON you can do the following:

<pre><code># This will return the second page of jobs with the default amount per page of 10.
jobs = px.jobs(page: 2)

# This will return the second page of jobs with 100 jobs per page
jobs = px.jobs(page: 2, per_page: 100)
</code></pre>

### Sorting

The following commands will allow you to sort your results by a certain value

<pre><code># Sort by value
jobs = px.jobs(sort_by: 'created')

# Sort by value (descending)
jobs = px.jobs(sort_by: 'created,desc')

# Sort by value (descending)
jobs = px.jobs(sort_by: 'created,asc')
</code></pre>

### Search

Search is similar to the ones above. Just add params onto the job method:

#### Number Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#number)

In order to get deeper params, use the " _ " instead of the "."" when entering the params. For example, 'processed_bytes' will be the same thing as 'processed.bytes' in an api call (example below).

<pre><code># This query will return all jobs that processed more than 1048576 bytes:
jobs = px.jobs(processed_bytes: '{gt}1048576')
</code></pre>

#### String Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#string)

<pre><code># This query will return all jobs that did not fail:
jobs = px.jobs(status: '{not}failed')
</code></pre>

#### Location Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#location)

<pre><code># This query will return all jobs that were near the longitude and latitude of [0.0176,-105.2797]:
jobs = px.jobs(processed_images_latlon: '{near}40.0176,-105.2797')
</code></pre>

#### Date Params

Check out all options: [here](https://github.com/6px-io/6px-api-docs#dates)

<pre><code># This query will return all the jobs created after right now:

# Need to convert the time to iso8601
formatted_time = Time.new.iso8601
jobs = px.jobs(created: "{gt}#{fomatted_time}")
</code></pre>

#### Chain Up Params

These commands can also be input with the pagination and sorting params like so:

<pre><code>formatted_time = Time.new.iso8601
jobs = px.jobs(page: 1, per_page: 50, sort_by: 'status', status: '{not}failed', created: "{gt}#{fomatted_time}")`
</code></pre>

## Methods

### Stucture of submitting a job to process images

#### Resizing one image
<pre><code>
# Initialize PX authenticated object
px = PX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)

# Setup images to be processed
images =  {snowboarding: 'https://www.drupal.org/files/test-all-the-things.jpg'}

# References which images to be processed per output block
outputs =  {snowboarding: false}

# The authenticated object
# Add the hash of the image you want to add
# Rotate the image 90 degress
# The output url - '6px' will put it on their 6px's hosting platform
# Tell 6px to output in a gif - Possible options: ['image/gif', 'image/jpeg', 'image/png'] - Default: 'image/jpeg'
# Tells 6px to process the 'snowboarding' image and rename it 'sideways_snowboarding'
# Contains the image details in a 'rotated_image' processed hash in the job json
# Submit the job to 6px

px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
    url('6px').
    type('image/png').
    tag('rotated_image').
  save
</code></pre>

#### Resizing five images into the same output
<pre><code>
# Initialize PX authenticated object
px = PX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)

# Setup images to be processed
images =  {
  img1: "http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg",
  img2: "http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg",
  img3: "http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg",
  img4: "http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg",
  img5: "http://media.npr.org/assets/img/2012/05/26/golden-gate-today_wide-8462da9949bef3d5c02aaa1f78e0a4344a3a597c.jpg"
}

# Setup outputs name mapping
outputs = {
  img1: 'processed_img1',
  img2: 'processed_img2',
  img3: 'processed_img3',
  img4: 'processed_img4',
  img5: 'processed_img5'
}

# The authenticated object
# Add the hash of the images you want to add
# Rotate the images 90 degress
# The output url - '6px' will put it on their 6px's hosting platform
# Tell 6px to output in a png - Possible options: ['image/gif', 'image/jpeg', 'image/png'] - Default: 'image/jpeg'
# Tells 6px to process the all five images
# Contains the image's details in a 'rotated_image' hash in the processed job json
# Submit the job to 6px

px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
    url('6px').
    type('image/png').
    tag('rotated_image').
  save
</code></pre>

#### Resizing five images into different outputs
<pre><code>
# Initialize PX authenticated object
px = PX.new(user_id: YOUR_USER_ID, api_key: YOUR_API_KEY, api_secret: YOUR_SECRET_API_KEY)

# Setup images to be processed
images =  {
  img1: 'URL_TO_IMG1',
  img2: 'URL_TO_IMG2',
  img3: 'URL_TO_IMG3',
  img4: 'URL_TO_IMG4',
  img5: 'URL_TO_IMG5'
}

# Setup outputs name mapping
rotated_outputs = {
  img1: 'rotated_img1,
  img2: 'rotated_img2,
  img3: 'rotated_img3,
  img4: 'rotated_img4,
  img5: 'rotated_img5
}

resized_outputs = {
  img1: 'resized_img1,
  img2: 'resized_img2,
  img3: 'resized_img3,
  img4: 'resized_img4,
  img5: 'resized_img5
}

# The authenticated object
# Add the hash of the images you want to add
# Each output block builds up another processing job that can be done in one API call
# The output url - '6px' will put it on their 6px's hosting platform
# Tell 6px to output in a png - Possible options: ['image/gif', 'image/jpeg', 'image/png'] - Default: 'image/jpeg'
# Tells 6px to process the all five images
# Contains the image's details in a 'rotated_image' and 'resized_outputs' hash in the processed job json
# Submit the job to 6px

px.
  inputs(images).
  output(rotated_outputs).
    rotate({degrees: 90}).
    url('6px').
    type('image/png').
  output(resized_outputs).
    resize({width: 200, width: 200}).
    url('6px').
    type('image/png').
  save
</code></pre>

All the available methods are listed: [here](https://github.com/6px-io/6px-api-docs#methods)

These methods can also be chained!

#### Rotate

This will rotate the image.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#rotate)

<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
  save
</code></pre>

#### Resize

This will resize the image.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#resize)

<pre><code>px.
  inputs(images).
  output(outputs).
    resize({height: 400, width: 400}).
  save
</code></pre>

#### Crop

This will crop the image.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#crop)

<pre><code>px.
  inputs(images).
  output(outputs).
    crop({height: 400, width: 400, x: 0, y: 0}).
  save
</code></pre>

#### Filter

This will apply filters to the image.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#filter)

<pre><code>px.
  inputs(images).
  output(outputs).
    filter({sepia: 70, gama: 45}).
  save
</code></pre>

#### Layer

This will layer the images on top of each other.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#layer)

<pre><code>inputs =  {
  img1: 'URL_TO_IMG1',
  img2: 'URL_TO_IMG2'
}

outputs =  {
  img1: 'combined_image',
}

px.
  inputs(images).
  output(outputs).
    layer({x: 0, y: 0, opacity: 0.5, ref: 'img2'}).
  save
</code></pre>

#### Analyze

This will analyze the image.

Full documentation of method options: [here](https://github.com/6px-io/6px-api-docs#analyze)

<pre><code>px.
  inputs(images).
  output(outputs).
    analyze({type: 'color', context: 'palette'}).
  save
</code></pre>

#### Chain up multiple!
<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
    resize({height: 400, width: 400}).
    crop({height: 400, width: 400, x: 0, y: 0}).
    filter({sepia: 70, gama: 45}).
    tag('so_much_manipulation').
  save
</code></pre>

## Additional Options

#### Tag

You can tag each output in the job for easier access to each images results

<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
    tag('rotated_img').
  save
</code></pre>

#### Type

Tell 6px to output in a png - Possible options: ['image/gif', 'image/jpeg', 'image/png'] - Default: 'image/jpeg'

<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
    type('image/png').
  save
</code></pre>

#### Data

Add additional custom data on your job

<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
  data({this_image_is: 'sweet'}).
  save
</code></pre>

#### Callback

Add a callback that will POST the job params to a url specified

<pre><code>px.
  inputs(images).
  output(outputs).
    rotate({degrees: 90}).
  callback('https://your-domain.com/callback').
  save
</code></pre>

Now that we have covered some of the simple use cases, feel free to refer to our documentation!

##[API Documentation](https://github.com/6px-io/6px-api-docs)

Keep us posted on the cool stuff you are doing by sending an email to <support@6px.io>. If you come across any issues or have suggestions please [open an issue on GitHub](https://github.com/6px-io/6px-node/issues).

[![Analytics](https://ga-beacon.appspot.com/UA-44211810-2/6px-ruby)](https://github.com/igrigorik/ga-beacon)
