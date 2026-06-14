# AWS Lab — Infrastructure as Code

A small, reproducible AWS environment built with Terraform — used to learn cloud engineering and security fundamentals **in public**. One command provisions a Linux server and its firewall; one command destroys it.

## What it provisions
- An **EC2 instance** — Ubuntu 24.04, `t3.micro`
- A **security group** (firewall) allowing SSH on port 22
- Outputs the server's public IP

## Skills demonstrated
- **Infrastructure as Code** — the whole environment defined in Terraform (`main.tf`), version-controlled
- **AWS** — EC2, security groups, IAM-scoped access
- **Lifecycle discipline** — build → inspect → destroy → rebuild, identically, on demand
- **Operational diagnosis** — real break/fix incidents (see writeups below)
- **Cost control** — $5 billing alarm first; every resource torn down after each session
- **Security / git hygiene** — state files and keys are `.gitignore`d (`*.tfstate`, `*.pem` are never committed — they can leak secrets)

## 📝 Break/fix writeups
Real failures, deliberately caused, diagnosed, and fixed — documented like incidents:
- **[01 — SSH blocked by the security group](writeups/01-ssh-blocked-by-security-group.md)** — a firewall misconfiguration, diagnosed from the *symptom* (timeout vs auth error) and fixed.

## Usage
```bash
terraform init      # one-time: download the AWS provider
terraform apply     # build it (review the plan, then approve)
terraform destroy   # tear it all down → $0
```

## The discipline
**Build → inspect → destroy → rebuild.**
- A **$5 billing alarm** goes up before anything is provisioned.
- The environment is destroyed after every session — no forgotten resources billing in the background.
- Because it's code, the exact same setup rebuilds anytime, identically.

— Jarrad Bermingham · [github.com/Jbermingham1](https://github.com/Jbermingham1)
