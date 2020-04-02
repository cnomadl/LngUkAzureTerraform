variable "remote_port" {
    description = ""
}

variable "tags" {
    type = map(string)
    description = "A map of the tags to use on the resources that you are deploying with htis module"
    default = {
        environment = "dev"
    }
}