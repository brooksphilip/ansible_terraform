import boto3

# Enter your instances here: ex. ['X-XXXXXXXX', 'X-XXXXXXXX']
#This is for rcrp-test-tableau
 
instances = [$instance]
ec2 = boto3.client('ec2', region_name=region)
 
def lambda_handler(event, context):
 
    ec2.stop_instances(InstanceIds=instances)
 
    print ('stopped your instances: ' + str(instances)) 