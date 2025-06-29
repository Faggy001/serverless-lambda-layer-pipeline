✅Week 7 Mentorship Project – Group B

✅GROUP B TEAM: Fagoroye Sanumi O.
                 & Lawal Jonathan
               
**TOPIC**: Automate Lambda Layer Management with GitHub Actions and Terraform


🧠 **What Are Lambda Layers**?
Think of a Lambda Layer like a shared toolbox. Instead of putting every tool in every bag (your Lambda functions), you create one central toolbox and let your functions borrow from it.

A Lambda Layer is a zip file that contains common code, libraries, or dependencies, which can be attached to one or more Lambda functions.

      ┌────────────┐
      │   User     │
      └────┬───────┘
           │ uploads file
           ▼
    ┌───────────────┐
    │ S3 Bucket     │◄────────────┐
    │ (inbound/)    │             │
    └────┬──────────┘             │
         │ triggers              ▼
         ▼               ┌────────────────┐
 ┌────────────────┐      │ GitHub Actions │
 │ Lambda Function │◄────│ Manual Trigger │
 │ (handler.py)    │      │ (workflow_dispatch) 
 └────┬────────────┘      └────────────────┘
      │
      ▼  uses
┌────────────┐
│ Lambda     │
│ Layer      │
│ (utils.py) │
└────┬───────┘
     │
     ▼ logs
┌──────────────┐
│ DynamoDB     │
│ FileMetadata │
└────┬─────────┘
     │
     ▼ publishes
┌─────────────┐
│ SNS Topic   │───► 📧 Email Notification
└─────────────┘



✅ **Why Use Lambda Layers**?
Here are the real-world benefits of using Lambda Layers in a production or scalable setup:

 1. **Code Reusability**
Instead of copying the same code into every Lambda function:

Place it in a shared utils.py or package.

Attach it as a Layer.

Now every Lambda can reuse it without duplication.

📌 **Example**: A parse_date() function that all your S3-triggered Lambdas use can live in one layer.

 2. **Cleaner, Smaller Handlers**
By removing utility code from the main Lambda:

Your handler.py stays focused only on logic specific to that function.

Smaller zip packages mean faster deployments.

📌 **Think**: One handler = one purpose. Layers = shared tools.

 3. **Faster Iteration**
When you update shared logic:

You just update the Layer.

No need to touch every Lambda individually.

Reduces risk of introducing new bugs into working functions.

📌 **Imagine**: Fixing a bug in one shared layer, not 10 duplicated files.

 4. **Supports Third-Party Libraries**
If you need Python packages like requests, pandas, or boto3 (specific versions):

Install them into a python/lib/... structure.

Zip them into a Layer.

Attach it once, reuse across multiple Lambdas.

📌 **Bonus**: No need to bundle libraries every time you update logic.

 5. **Security and Compliance**
Layers isolate common dependencies from function code.

Makes auditing easier — especially for sensitive code or libraries.

Helps enforce consistent versions of critical packages.

📌 **Example**: Your encryption functions or validation logic are centrally managed in one layer.

 6. **Scalability and Team Collaboration**
Multiple developers or teams can maintain the Layer independently.

Helps standardize tooling and practices across teams/functions.

Great for microservices where Lambdas need consistent behavior.

📌 **Think**: A team maintaining a data formatting layer, while another builds new features.

 7. **Automation-Friendly**
Using Terraform and GitHub Actions:

Layers can be versioned, zipped, deployed, and reattached automatically.

Makes your CI/CD pipeline cleaner and more maintainable.

📌 **Workflow**: Push to main → GitHub zips Layer → AWS gets updated.

![Github](<images/Screenshot 2025-06-29 095847.png>)

![Proof](<images/Screenshot 2025-06-29 095941.png>)


![layer](<images/Screenshot 2025-06-29 094935.png>)