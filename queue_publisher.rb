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

# data set array of hashes
tickets = [
  { body: '20151217A', agent: 'crom', tech: 'bjsm', category: 'Cellphones::Screens' },
  { body: '20151217B', agent: 'ieo', tech: 'eal', category: 'Computers::Desktop::Motherboard' },
  { body: '20151217C', agent: 'rjgs', tech: 'jab', category: 'Computers::Laptops::Keyboard' },
  { body: '20151217D', agent: 'jaof', tech: 'maom', category: 'Home::Stoves::Grill' },
  { body: '20151217E', agent: 'tmmo', tech: 'kvm', category: 'Home::AirConditioners::Electrical' },
  { body: '20151217F', agent: 'beap', tech: 'haa', category: 'Videogames::Playstation::PS4::DiscTray' }
]

tickets.each do |tkt|
  message_details = {
    queue_url: keys[0]['QUEUE_URL'],
    message_body: tkt[:body],
    delay_seconds: 1,
    message_attributes: {
      "agent" => { string_value: tkt[:agent], data_type: "String" },
      "technician" =>  { string_value: tkt[:tech], data_type: "String" },
      "category" => { string_value: tkt[:category], data_type: "String" },
      }
  }
  sqs.send_message(message_details)
end
