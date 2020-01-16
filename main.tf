provider "aws"{
 
   region   = "us-east-1"
}
resource "aws_s3_bucket" "terraform_state"{

    bucket       =        "terraform-up-running-demo1"
    lifecycle {
    prevent_destroy  = true
   
}
    versioning{

     enabled = true 
}
 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
}


terraform{

 backend "s3"{

  bucket         =   "terraform-up-running-demo1"
  key            =   "global/env/terraform.tfstate"
  region         =   "us-east-1"
  dynamodb_table =   "terraform-state-lock-dynamo"
  encrypt        =   true


}


}

