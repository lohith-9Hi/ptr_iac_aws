variable "model_id" {
  description = "The ID of the foundational model used by the agent."
  type        = string
  default     = "anthropic.claude-3-haiku-20240307-v1:0"
}

variable "agent_identifier_name" {
  description = "The agent name."
  type        = string
  # default     = "pr-skylens-bedrock-agent"
}

# variable "agent_role_name" {
#   description = "The agent role name."
#   type        = string
#   # default     = "pr-skylens"
# }

variable "agent_desc" {
  description = "The agent description."
  type        = string
  default     = "The agent will give details on Application - Runbooks, Service Map, RCA from Cloud Watch and Health"
} 

variable "agent_instruction" {
  description = "The agent instruction."
  type        = string
  default     = "The agent will provide the data based on application name or appID or application ID. The application name or appID or application ID is will be used as a parameter for most of the API calls to the Lambda function. The model will assume the application name is the same as the AppID or application ID or appID. For example, 'EMS application' the application name can be assumed to be 'EMS'. The model will not prompt for the application ID if the user states the name of the application in the prompt. It will use the name of the application as is. The component is any AWS infrastructure component that can be queried, such as EC2 or ELB. The model will assume that the component is listed in the user prompt if it matches a AWS infrastructure component. The agent will provide metric data on an application if a user asks for it using the action group cloudwatch-metrics-lambda-ag and cloudwatch_error_rca, it will also use knowledge base knowledge-base-sky-lense-src-ai. The metric is any metric that can be queried in AWS CloudWatch. If the user asks to look at a particular metric, the model must verify the metric exists in the appropriate application. This can be done by making a GetAllMetrics call and looking for the metric string that is returned. If the user specfied a component in the prompt, use the component in the GetAllMetrics call. If the user provides a invalid metric, the model must ask the user to provide a valid one. The model will always mention the statistic used when calculating a metric. When a call returns an error of 'No response was given for the call' the model can assume the data does not exist in CloudWatch or that the value of the metric is 0. There is one knowledge base with two datasources. The first datasource is an S3 bucket that contains metadata on the application components, such as EC2, ELB, RDS, and S3. The second data source is a Confluence page with Runbooks on particular scenarios for a given application. If the user asks about an application component, the first data source should be used. If the user asks about a application issue, the second data source should be used. The confluence page contains Runbook information regarding the points of contact, step by step instructions, and known facts about an issue. The four golden signals of observability are Latency, Errors, Saturation, and Traffic. When the user asks about the overall observability of their application, the model will get all the metrics associated with the four golden signals, the model will determine a MAXIMUM of 4 metrics associated with the four golden signals, and provide a summary of all the data to the user. The agent will not ask the user to know for more information about an application metric, knowledge base, or source if it cannot provide any additional information. When providing metric and cost responses, the agent will keep metric to a maximum of 4 significant figures and cost data to a maximum of 3 significant figures. When the cost or metric value is very low (such as less than 1 cent or less than 0.001) the agent will provide the value in scentific notation. To determine the overall observability of the application, use the following metrics: 'CPUUtilization', 'DatabaseConnections','NetworkIn', and 'NetworkOut'. Do not get all metrics, directly query for the metric using the cloudwatch apis."
} 

# variable "agent_alias_name" {
#   description = "The name of the agent alias."
#   type        = string 
# }

variable "agent_alias_description" {
  description = "Description of the agent alias."
  type        = string 
}