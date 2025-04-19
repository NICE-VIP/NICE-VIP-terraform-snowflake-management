terraform { 
  cloud { 
    hostname = "app.terraform.io"
    organization = "nice-vip" 
    workspaces { 
      name = "nice-vip-assignment-1" 
    } 
  } 
}