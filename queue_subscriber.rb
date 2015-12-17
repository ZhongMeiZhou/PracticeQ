require 'aws-sdk'
require 'yaml'

# load keys from file
keys = YAML.load(File.read('config/aws_key.yml'))

# create credentials
aws_access = Aws::Credentials.new(keys[0]['AWS_ACCESS_KEY_ID'], keys[0]['AWS_SECRET_ACCESS_KEY'])

# are credentials set?
puts aws_access.set?

# create the sqs object
sqs = Aws::SQS::Client.new(
  region: keys[0]['AWS_REGION'],
  credentials: aws_access,
)

# get the messages, this gets the last one
resp = sqs.receive_message(
  {
    queue_url: keys[0]['QUEUE_URL'],
    attribute_names: ["All"],
    message_attribute_names: ["agent","technician","category"],
    max_number_of_messages: 10,
    visibility_timeout: 1,
    wait_time_seconds: 1
  }
)


resp.messages.each do |msg|
  # do something with the message
  puts "ID: #{msg.message_id} | BODY: #{msg.body}"
  # delete the message
  sqs.delete_message( { queue_url: keys[0]['QUEUE_URL'], receipt_handle: msg.receipt_handle })
end

# docs.aws.amazon.com/sdkforruby/api/Aws/SQS/Client.html

#resp.messages #=> Array
#resp.messages[0].message_id #=> String
#resp.messages[0].receipt_handle #=> String
#resp.messages[0].md5_of_body #=> String
#resp.messages[0].body #=> String
#resp.messages[0].attributes #=> Hash
#resp.messages[0].attributes["QueueAttributeName"] #=> String
#resp.messages[0].md5_of_message_attributes #=> String
#resp.messages[0].message_attributes #=> Hash
#resp.messages[0].message_attributes["String"].string_value #=> String
#resp.messages[0].message_attributes["String"].binary_value #=> IO
#resp.messages[0].message_attributes["String"].string_list_values #=> Array
#resp.messages[0].message_attributes["String"].string_list_values[0] #=> String
#resp.messages[0].message_attributes["String"].binary_list_values #=> Array
#resp.messages[0].message_attributes["String"].binary_list_values[0] #=> IO
#resp.messages[0].message_attributes["String"].data_type #=> String
