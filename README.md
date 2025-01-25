# 🚀 EC2 Instance Connect Terraform Demo

This Terraform configuration deploys **Amazon Linux 2 and Amazon Linux 2023 EC2 instances** with **EC2 Instance Connect** for secure SSH access **without key pairs**.

---

## **📌 Features**

✅ Creates an **EC2 instance** running **Amazon Linux 2** and **Amazon Linux 2023**.\
✅ Uses **EC2 Instance Connect** for secure SSH access (no key pairs required).\
✅ Configures **VPC, Public Subnet, Security Group, and IAM Roles**.\
✅ Uses **AWS-managed prefix lists** for EC2 Instance Connect security.

---

## **📂 Project Structure**

```plaintext
.
├── main.tf                  # Terraform configuration for EC2 instances, IAM, VPC, and Security Groups
├── README.md                # Documentation (this file)
└── variables.tf             # Optional: Stores configurable parameters (if needed)
```

---

## **🛠 Prerequisites**

- **Terraform** installed ([Download](https://developer.hashicorp.com/terraform/downloads)).\
- **AWS CLI** installed ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)).\
- **AWS Credentials** configured (`~/.aws/credentials` or environment variables).

### **🔹 EC2 Instance Connect Prerequisites**

EC2 Instance Connect requires:\
✅ **Public EC2 instances** (must be in a public subnet with a public IP).\
✅ **Amazon Linux 2 or Ubuntu** (EC2 Instance Connect is not available on all OS).\
✅ **Security group rules allowing EC2 Instance Connect (AWS-managed prefix list used in Terraform).**

---

## **🚀 Deployment Steps**

### **1️⃣ Clone the Repository (If Applicable)**

```sh
git clone git@github.com:jdevto/tf-aws-ec2-instance-connect-demo.git
```

### **2️⃣ Initialize Terraform**

```sh
terraform init
```

### **3️⃣ Preview Changes Before Applying**

```sh
terraform plan
```

### **4️⃣ Apply the Configuration**

```sh
terraform apply -auto-approve
```

### **5️⃣ Find the Instance in AWS Console and Connect via EC2 Instance Connect**

- Go to **EC2 → Instances → Select Instance → Click "Connect" → Choose "EC2 Instance Connect"**.

---

## **🛑 Cleanup**

To **destroy all resources** created by this demo, run:

```sh
terraform destroy -auto-approve
```

---

## **🔹 Troubleshooting EC2 Instance Connect Issues**

### **❌ EC2 Instance Connect Option is Disabled in AWS Console**

✅ Ensure **instance is in a public subnet** and has a **public IP**.\
✅ **Security group must allow EC2 Instance Connect traffic** (AWS-managed prefix list).

### **❌ "Instance is not reachable" Error**

✅ The instance must be running **Amazon Linux 2 or Ubuntu**.\
✅ EC2 Instance Connect **does not work on RHEL, Windows, or AL2023**.

### **❌ "No SSH key pair found" Error**

✅ No key pairs are required. **AWS injects a temporary key** automatically.

---

## **📌 Notes**

- **Amazon Linux 2 comes with EC2 Instance Connect pre-installed**.
- **Amazon Linux 2023 requires manual installation of EC2 Instance Connect** (handled in Terraform `user_data`).
- **The EC2 security group only allows SSH from AWS EC2 Instance Connect** using **AWS-managed prefix lists**.
- **No SSH key pairs are needed**, improving security.

---

## **📧 Need Help?**

If you have any issues, feel free to open an **issue** or reach out! 🚀
