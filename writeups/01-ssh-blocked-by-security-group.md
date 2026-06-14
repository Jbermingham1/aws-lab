# Break/Fix 01 — SSH blocked by the security group
*AWS · EC2 · Terraform — a deliberate break, diagnosed and fixed*

## Summary
I deliberately broke SSH access to an EC2 instance by mis-configuring its security group (firewall), then used the failure symptom — a timeout, not an instant rejection — to diagnose it as a firewall issue rather than a key issue, corrected the rule, and restored access. All changes managed as code with Terraform.

## Environment
A single Ubuntu EC2 instance and its security group (firewall), both defined and managed as code with Terraform (`main.tf`). Access via SSH using a `.pem` key.

## What I changed (the break)
I changed the security group's **ingress** rule for SSH — the rule that lets the shell connect in — from port **22** (the SSH port) to **2222**. Edited `main.tf`, saved, and ran `terraform apply` to deploy the change to the live firewall.

## Symptom
Ran `ssh -i ~/lab-key.pem ubuntu@<public-ip>` — it hung, then timed out, with no immediate response.

## Diagnosis
A **timeout** — rather than an instant `Permission denied` — was the tell: the connection couldn't even *reach* the server, so this was a firewall problem, not a key problem. Key/auth failures reject immediately; a hang means packets are being dropped at the firewall. The security group was only allowing port 2222, so SSH (port 22) had nowhere to land.

## Fix
Reopened `main.tf`, found the ingress section, corrected the port from 2222 back to **22**, saved, then ran `terraform apply` to push the corrected rule to the live firewall. The file edit alone changes nothing — `apply` is what makes it real; it updated the security group **in place**, and the instance kept running on the same IP. SSH then connected successfully.

## Root cause
The security group's SSH ingress rule was set to the wrong port (2222 instead of 22), so the firewall silently blocked all SSH traffic on port 22.

## Lesson / what I'd check first next time
Read the error condition first — **the symptom tells you the layer.** An instant connection failure points to a key/auth issue; a timeout points to a firewall (security group) misconfiguration. Diagnose the symptom before changing anything.
