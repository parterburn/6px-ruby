class SixPX

  include HTTParty

  base_uri 'https://api.6px.io/v1/'
  headers 'Content-Type' => 'application/json'

  # Set up the authroized url and parameters
  def initialize(args)
    user_id = args[:user_id]
    api_key = args[:api_key]
    api_secret = args[:api_secret]
    self.class.base_uri << "/users/#{user_id}/"
    self.class.default_params key: api_key, secret: api_secret
  end


  def get_jobs(*query)
    response = self.class.get("jobs", query: query.first)
    ap JSON.parse(response.body)
    return JSON.parse(response.body)
  end

  def post_images(input, method, options, destination="")
    params = {
      input: input,
      output: [
        {
          methods: [
            {
              method: method,
              options: options
            }
          ],
          type: 'image/jpeg',
          ref: {
            img: false
          },
          url: destination
        }
      ]
    }

    self.class.post("jobs", body: params.to_json)
  end
end