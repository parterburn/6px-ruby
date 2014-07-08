# OUDATED WILL BE UPDATING

# Ruby Wrapper for 6px API

### Setup

To install this gem on your system, run:

`gem install six_px`

If you want to add this gem to a rails app, then add the following line to your Gemfile:

`gem 'six_px''

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

<pre><code># This query will return all jobs that did not fail:
jobs = six_px.jobs(status: '{not}failed')
</code></pre>

These commands can also be input with the pagination and sorting params like so:

`jobs = six_px.jobs(page: 1, per_page: 50, sort_by: 'status', status: '{not}failed')`

## Methods

All the available methods are listed: [here](https://github.com/6px-io/6px-api-docs#methods)

### Example query of resizing 5 different images
<pre><code># Set up the hash of images you want to process
inputs =  {
  'img1' => 'http://donaldmurrayexpat.com/wp-content/uploads/2014/02/Cool-2.jpg',
  'img2' => 'http://donaldmurrayexpat.com/wp-content/uploads/2014/02/Cool-2.jpg',
  'img3' => 'http://donaldmurrayexpat.com/wp-content/uploads/2014/02/Cool-2.jpg',
  'img4' => 'http://donaldmurrayexpat.com/wp-content/uploads/2014/02/Cool-2.jpg'
}

# Build the hash of methods you want to perform on the images
# You can keep chaining them or just send one. Up to you!
methods = [
  {
    'method' => 'resize',
    'options' => {
      'height' => 400,
      'width' => 400
    }
  },
  {
    'method' => 'filter',
    'options' => {
      'colorize' => {'hex' => '#000', 'strength' => 30 }
    }
  }
]

# Now send the payload!
# The image type can be: ['jpeg', 'png', 'gif'] and defaults to 'jpeg' if not entered
# The output url is also options.

response = six_px.process_images(inputs, methods, 'jpeg', 's3://key:secret@bucket/path')
</code></pre>


# NEED TO DO
 * Figure out how to include nested search params
 * Convert dates from Ruby object to ISO 8601
 * Rescue errors
 * Learn more about the data object
 * Learn more about the callback call

