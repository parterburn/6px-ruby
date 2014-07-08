require 'json'

class SixPX
  include HTTParty

  METHOD_NAMES = [:rotate, :resize, :crop, :filter, :layer, :analyze]

  base_uri 'https://api.6px.io/v1/'
  headers 'Content-Type' => 'application/json'

  # Set up the authroized url and parameters
  def initialize(args)
    user_id = args[:user_id]
    api_key = args[:api_key]
    api_secret = args[:api_secret]
    self.class.base_uri << "/users/#{user_id}/"
    self.class.default_params key: api_key, secret: api_secret
    @payload = {}
    @inputs = {}
    @methods = []
    @refs = {}
    @type = 'jpeg'
    @url = ''
    @data = {}
    @callback = ''
  end

  # For querying what jobs have been submitted
  def jobs(*query)
    query = query.first
    job_id = query.delete(:job_id) if query
    url = job_id ? "jobs/#{job_id}" : "jobs"
    query = clean_up_search_params(query)
    response = self.class.get(url, query: query).body
    JSON.parse(response)
  end

  # Sets images to that need to be processed
  def inputs(inputs)
    @inputs = inputs
    self
  end

  # Add whichs images to process
  def refs(refs)
    @refs = refs
    self
  end

  # Sets what type the output should be in. Default is jpeg.
  def type(type)
    @type = type
    self
  end

  # Sets output url
  def url(url)
    @url = url
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
  def send
    payload = build_payload.to_json
    empty_variables
    response = self.class.post("jobs", body: payload).body
    JSON.parse(response)
  end

  private

  def clean_up_search_params(params)
    parsed_hash = {}
    params.each {|i,k| parsed_hash[i.to_s.gsub('_', '.')] = k }
    parsed_hash
  end

  # Add methods to method hash
  def add_method(method, options)
    @methods << {
      'method' => method,
      'options' => options
    }
  end

  # Builds the final payload to send
  def build_payload
    {
      input: @inputs,
      output: [
        {
          methods: @methods,
          type: "image/#{@type}",
          ref: @refs,
          url: @url
        }
      ],
      data: @data,
      callback: {
        url: @callback
      }
    }
  end

  # Resets instance variables after request is sent
  def empty_variables
    @payload = {}
    @inputs = {}
    @methods = []
    @refs = {}
    @type = 'jpeg'
    @url = ''
    @data = {}
    @callback = ''
  end
end