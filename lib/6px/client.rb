require 'json'
require 'base64'

class PX
  include HTTParty

  METHOD_NAMES = [:rotate, :resize, :crop, :filter, :layer, :analyze]

  base_uri ''
  headers 'Content-Type' => 'application/json'

  # Set up the authroized url and parameters
  def initialize(args)
    user_id = args[:user_id]
    api_key = args[:api_key]
    api_secret = args[:api_secret]
    self.class.base_uri "https://api.6px.io/v1/users/#{user_id}"
    self.class.default_params key: api_key, secret: api_secret
    @inputs = {}
    @outputs = []
    @output = {}
    @methods = []
    @data = {}
    @callback = ''
  end

  # For querying what jobs have been submitted
  def jobs(*query)
    query = query.first
    job_id = query.delete(:job_id) if query
    url = job_id ? "/jobs/#{job_id}" : "/jobs"
    query = clean_up_search_params(query)
    response = self.class.get(url, query: query).body
    JSON.parse(response)
  end

  def output(images)
    @outputs << @output unless @output.empty?

    @output = {
      ref: images,
      type: 'image/jpeg',
      url: '',
      methods: [],
      tag: ''
    }

    self
  end

  # Sets images to that need to be processed
  def inputs(inputs)
    inputs.each do |k,v|
      puts k, v
      @inputs[k] = encode_image(v)
    end

    self
  end

  # Sets what type the output should be in. Default is jpeg.
  def type(type)
    @output[:type] = type
    self
  end

  # Sets output url
  def url(url)
    @output[:url] = url
    self
  end

  def tag(tag)
    @output[:tag] = tag
    self
  end

  # Sets additional data on job
  def data(data)
    @data = data
    self
  end

  # Sets callbacks on job
  def callback(callback)
    @callback = callback
    self
  end

  # Defines all functions for methods
  METHOD_NAMES.each do |mn|
    define_method(mn) do |params|
      add_method(mn.to_s, params)
      self
    end
  end

  # Builds and sends the payload to 6px
  def save
    payload = build_payload.to_json
    empty_variables
    response = self.class.post("/jobs", body: payload)
    JSON.parse(response.body)
  end

  private

  # Replaces underscores with periods in hash
  def clean_up_search_params(params)
    parsed_hash = {}
    params.each {|i,k| parsed_hash[i.to_s.gsub('_', '.')] = k }
    parsed_hash
  end

  # Encodes the images in Base64 if they are not hosted
  def encode_image(url)
    return url if URI.parse(url).scheme

    raw_image = open(url, 'r').read
    image_type = image_type(url)
    encoded_image = Base64.encode64(raw_image)

    "data:#{image_type};base64,#{encoded_image}"
  end

  def image_type(path)
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
    jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
    case IO.read(path, 10)
    when /^GIF8/ then 'image/gif'
    when /^#{png}/ then 'image/png'
    when /^#{jpg}/, /^#{jpg2}/ then 'image/jpg'
    end
  end

  # Add methods to method hash
  def add_method(method, options)
    @output[:methods] << {
      'method' => method,
      'options' => options
    }
  end

  # Builds the final payload to save
  def build_payload
    @outputs << @output

    payload = {
      input: @inputs,
      data: @data,
      callback: {
        url: @callback
      },
      output: @outputs
    }

    payload
  end

  # Resets instance variables after request is sent
  def empty_variables
    @inputs = {}
    @methods = []
    @data = {}
    @callback = ''
    @outputs = []
    @output = {}
  end
end
