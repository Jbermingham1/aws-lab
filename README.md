# AWS Lab — Infrastructure as Code

A small, reproducible AWS environment built with Terraform. One command provisions a
Linux server and its firewall; one command destroys it. Built while learning cloud in public.

## What it provisions
- An **EC2 instance** — Ubuntu 24.04, `t3.micro`
- A **security group** allowing SSH (port 22)
- Outputs the server's public IP

## Usage
```bash
terraform init      # one-time: download the AWS provider
terraform apply     # build it
terraform destroy   # tear it all down
```

## The discipline
**Build → inspect → destroy → rebuild.**

- A **$5 billing alarm** goes up before anything is provisioned.
- The environment is destroyed after every session — no forgotten resources billing in the background.
- Because it's code, the exact same setup rebuilds anytime, identically.

— Jarrad Bermingham · github.com/Jbermingham1
