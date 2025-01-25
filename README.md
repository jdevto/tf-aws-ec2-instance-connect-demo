# 🚀 EC2 Instance Connect & AWS SSM Demo

This Terraform configuration deploys an **Amazon Linux 2 and Amazon Linux 2023 EC2 instance** with **EC2 Instance Connect** and **AWS Systems Manager (SSM) Session Manager** for remote access.

---

## **📌 Features**

✅ Creates an **EC2 instance** running **Amazon Linux 2** and **Amazon Linux 2023**
✅ Uses **EC2 Instance Connect** for secure SSH access (no key pairs required)
✅ Enables **AWS SSM Session Manager** for remote access
✅ Configures **VPC, Public Subnet, Security Group, and IAM Roles**
✅ Uses **AWS-managed prefix lists** for EC2 Instance Connect security

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

- **Terraform** installed ([Download](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** installed ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- **AWS Session Manager Plugin** installed ([Installation Guide](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html))
- **AWS Credentials** configured (`~/.aws/credentials` or environment variables)

### **Installing AWS SSM Session Manager Plugin**

If you encounter the error `SessionManagerPlugin is not found`, install the plugin for your operating system:

#### **Debian/Ubuntu**

```sh
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
```

#### **Amazon Linux 2 & RHEL 7**

```sh
sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
```

#### **Amazon Linux 2023 & RHEL 8/9**

```sh
sudo dnf install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
```

#### **Windows**

Download and install from: [AWS SSM Plugin for Windows](https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe)

Alternatively, download the zipped version:

```sh
https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPlugin.zip
```

Unzip and run the installer.

#### **macOS**

```sh
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```

Verify installation:

```sh
session-manager-plugin --version
```

---

## **🚀 Deployment Steps**

1️⃣ **Clone the repository (if applicable)**

   ```sh
   git clone <repository-url>
   cd <project-directory>
   ```

2️⃣ **Initialize Terraform**

   ```sh
   terraform init
   ```

3️⃣ **Preview changes before applying**

   ```sh
   terraform plan
   ```

4️⃣ **Apply the configuration**

   ```sh
   terraform apply -auto-approve
   ```

5️⃣ **Find the instance in AWS Console and connect via EC2 Instance Connect**

- Go to **EC2 → Instances → Select Instance → Click "Connect" → Choose "EC2 Instance Connect"**.

6️⃣ **Alternatively, connect using AWS SSM Session Manager**

   ```sh
   aws ssm start-session --target i-xxxxxxxxxxxxxxxxx
   ```

---

## **🛑 Cleanup**

To **destroy all resources** created by this demo, run:

```sh
terraform destroy -auto-approve
```

---

## **📌 Notes**

- **Amazon Linux 2 has EC2 Instance Connect pre-installed**, but **Amazon Linux 2023 requires manual installation** (handled in `user_data`).
- The **EC2 security group only allows SSH from AWS EC2 Instance Connect** using **AWS-managed prefix lists**.
- **No SSH key pairs are needed**, improving security.
- **Ensure AWS SSM Session Manager Plugin is installed** on your local machine before using `aws ssm start-session`.

---

## **📧 Need Help?**

If you have any issues, feel free to open an **issue** or reach out! 🚀
