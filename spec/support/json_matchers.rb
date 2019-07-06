require 'json'

RSpec::Matchers.define :to_have_the_json do |json|
  def get_body(response)
    return response.body if response.respond_to? :body

    response
  end

  match do |response|
    get_body(response) == JSON.generate(json)
  end

  failure_message do |response|
    body = get_body(response)
    return "expected a JSON to include #{json} but got #{body}"
  end
end
