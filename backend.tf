terraform { 
  cloud { 
    
    organization = "nice-vip" 

    workspaces { 
      name = "nice-renew-monitoring" 
    } 
  } 
}