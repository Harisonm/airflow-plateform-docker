provider "google" { 
    alias = "impersonate" 
    scopes = [ "https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/iam","https://bigquerydatatransfer.googleapis.com"]
}