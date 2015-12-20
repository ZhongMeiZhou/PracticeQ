require 'aws-sdk'
require 'config_env'

ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")

sqs = Aws::SQS::Client.new
q_url = sqs.get_queue_url(queue_name: 'SOA_queue').queue_url

msg = {usernames: ['nikki','annie']}
sqs.send_message(queue_url: q_url, message_body: msg.to_json)
