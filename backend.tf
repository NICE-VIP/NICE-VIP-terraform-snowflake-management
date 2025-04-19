terraform { 
  cloud { 
    
    organization = "nice-vip" 

    workspaces { 
      name = "nice-vip-assignment-1" 
    } 
  } 
}