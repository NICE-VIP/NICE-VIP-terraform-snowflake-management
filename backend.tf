terraform { 
  cloud { 
    
    organization = "nice-vip" 

    workspaces { 
      name = "nice-vip-storage" 
    } 
  } 
}