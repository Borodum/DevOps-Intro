# Lab 10 Submission — Cloud Computing Fundamentals

## Task 1: Artifact Registries Research

### 1.1 Cloud Provider Artifact Registry Services

| Cloud Provider | Service Name | Launched |
|----------------|--------------|----------|
| **AWS** | Amazon Elastic Container Registry (ECR) + AWS CodeArtifact | ECR: 2015, CodeArtifact: 2020 |
| **GCP** | Google Artifact Registry (successor to Container Registry) | 2021 (Artifact Registry GA) |
| **Azure** | Azure Container Registry (ACR) + Microsoft Artifact Registry | ACR: 2016 |

### 1.2 Key Features Comparison

| Feature | AWS ECR + CodeArtifact | GCP Artifact Registry | Azure ACR |
|---------|------------------------|----------------------|-----------|
| **Container Images** | ✅ Docker, OCI | ✅ Docker, OCI | ✅ Docker, OCI |
| **Helm Charts** | ✅ | ✅ | ✅ |
| **npm packages** | ✅ (CodeArtifact) | ✅ | ❌ (use npmjs or self-hosted) |
| **Maven/Java** | ✅ (CodeArtifact) | ✅ | ❌ (use Maven Central) |
| **Python (PyPI)** | ✅ (CodeArtifact) | ✅ | ❌ |
| **NuGet (.NET)** | ✅ (CodeArtifact) | ✅ | ✅ |
| **Security Scanning** | ✅ ECR Basic Scanning | ✅ (On-demand + Continuous) | ✅ (Integration with Defender) |
| **Geo-Replication** | ✅ (Cross-region replication) | ✅ (Multi-region) | ✅ (Geo-replication tiers) |
| **Vulnerability Scanning** | ✅ (Basic + Enhanced) | ✅ (On-demand, Continuous) | ✅ (Defender for Cloud) |
| **Lifecycle Policies** | ✅ | ✅ | ✅ |
| **IAM Integration** | ✅ (IAM) | ✅ (Cloud IAM) | ✅ (Azure AD + RBAC) |
| **CI/CD Integration** | CodePipeline, GitHub, GitLab | Cloud Build, Cloud Run, GKE | Azure Pipelines, GitHub Actions |
| **Cost Model** | Storage + Data transfer | Storage + Data transfer + Operations | Storage + Data transfer |

### 1.3 Supported Artifact Types Details

**AWS ECR (Container Registry):**
- Docker container images (OCI-compatible)
- OCI artifacts (custom artifacts)
- Helm charts (via ECR native support)
- Open Container Initiative (OCI) images

**AWS CodeArtifact (Package Registry):**
- npm, yarn (JavaScript/TypeScript)
- Maven, Gradle (Java)
- pip, twine (Python)
- NuGet (.NET/C#)
- SwiftPM (Swift)
- Generic packages

**GCP Artifact Registry (Unified):**
- Container images (Docker, OCI)
- Helm charts
- Java (Maven/Gradle)
- Node.js (npm)
- Python (PyPI)
- Go modules
- .NET (NuGet)
- Apt/Deb packages (Ubuntu/Debian)

**Azure Container Registry:**
- Docker container images
- OCI artifacts
- Helm charts
- Open Container Initiative (OCI) images
- Base images for Azure Red Hat OpenShift

### 1.4 Integration Capabilities

| Integration | AWS | GCP | Azure |
|-------------|-----|-----|-------|
| **Kubernetes** | EKS (native) | GKE (native) | AKS (native) |
| **Build Services** | CodeBuild | Cloud Build | Azure Pipelines |
| **Serverless** | Lambda, ECS, Fargate | Cloud Run | Container Instances, Functions |
| **GitOps Tools** | ArgoCD, Flux (via OIDC) | ArgoCD, Flux | ArgoCD, Flux |
| **GitHub Actions** | ✅ (Native OIDC) | ✅ (Native OIDC) | ✅ (Native OIDC) |
| **GitLab CI** | ✅ (via OIDC) | ✅ (via OIDC) | ✅ (via OIDC) |
| **Terraform** | ✅ | ✅ | ✅ |
| **Pulumi** | ✅ | ✅ | ✅ |

### 1.5 Pricing Comparison (as of 2026)

| Pricing Component | AWS ECR | GCP Artifact Registry | Azure ACR |
|-------------------|---------|----------------------|-----------|
| **Storage (per GB/month)** | $0.10 | $0.10 (standard) | $0.10 (premium tier) |
| **Data Transfer (out to internet)** | $0.09/GB (first 10TB) | $0.12/GB | $0.087/GB |
| **Operations (PUT/GET requests)** | $0.05 per 1,000 requests | Included up to 50GB | Included in storage tier |
| **Free Tier** | 500 MB/month | 5GB/month | 5GB/month (Basic tier) |
| **Vulnerability Scanning** | Free (Basic), $0.03/image (Enhanced) | Free (continuous) | Included (Defender) |

### 1.6 Analysis: Multi-Cloud Artifact Registry Strategy

**Recommendation:** Use provider-native registries with a centralized orchestrator

**Why choose this approach:**
1. **Performance:** Lowest latency for deployments within each cloud
2. **Cost:** No cross-cloud data transfer fees
3. **Security:** Native IAM integration with cloud provider
4. **Compliance:** Data residency requirements satisfied

**For multi-cloud, I would use:**
- **Primary:** GCP Artifact Registry (most comprehensive format support, unified interface)
- **Secondary:** AWS ECR for AWS deployments, ACR for Azure deployments
- **Synchronization:** Use tools like `skopeo` or Cloudflare Tiered Storage for cross-region sync

**Key Decision Factors:**
- GCP offers the widest native package format support
- AWS has the most mature container scanning ecosystem
- Azure has the strongest .NET/NuGet integration

---

## Task 2: Serverless Computing Platform Research

### 2.1 Cloud Provider Serverless Services

| Cloud Provider | Primary Service | Alternative/Related |
|----------------|----------------|---------------------|
| **AWS** | AWS Lambda (2014) | App Runner, Fargate (container-based) |
| **GCP** | Cloud Functions (2nd gen) | Cloud Run (container-based) |
| **Azure** | Azure Functions (2016) | Container Apps, Logic Apps |

### 2.2 Feature Comparison Matrix

| Feature | AWS Lambda | GCP Cloud Functions (2nd gen) | Azure Functions |
|---------|------------|------------------------------|-----------------|
| **Max Execution Time** | 15 minutes | 60 minutes | 10 minutes (Premium: 60 min) |
| **Memory per Function** | 128MB - 10GB | 128MB - 32GB | 128MB - 14GB |
| **CPU per Function** | 1-6 vCPU (proportional to memory) | 1-8 vCPU | 1-4 vCPU |
| **Max Request Body Size** | 6MB (sync), 256KB (async) | 10MB | 100MB (Premium) |
| **Concurrent Executions** | 1,000 (soft limit, can increase) | 1,000 (default, can increase) | 200 (Consumption), 10-1000 (Premium) |
| **Cold Start Latency** | 100-300ms (Node/Python), 500ms+ (Java/.NET) | 100-200ms (Node/Python), 300ms+ (Java) | 200-400ms (Node/Python), 500ms+ (Java/.NET) |
| **Ephemeral Storage** | 512MB (/tmp) | 512MB (/tmp) | 500MB (/tmp) |

### 2.3 Language & Runtime Support

| Runtime | AWS Lambda | GCP Cloud Functions | Azure Functions |
|---------|------------|---------------------|-----------------|
| **Node.js** | 18, 20, 22 | 18, 20, 22 | 18, 20, 22 |
| **Python** | 3.9, 3.10, 3.11, 3.12 | 3.9, 3.10, 3.11, 3.12 | 3.9, 3.10, 3.11, 3.12 |
| **Java** | 11, 17, 21 | 11, 17, 21 | 11, 17, 21 |
| **Go** | 1.x | ✅ | ✅ |
| **.NET/C#** | 6, 8 (Custom Runtime) | ❌ | 6, 8, Framework 4.8 |
| **Ruby** | ✅ | ❌ | ❌ |
| **PHP** | Custom Runtime | ❌ | ❌ |
| **Rust** | Custom Runtime | Custom Runtime | Custom Runtime |
| **PowerShell** | ❌ | ❌ | ✅ |
| **Custom Containers** | ✅ | ✅ | ✅ |

### 2.4 Trigger & Event Sources

| Event Source | AWS Lambda | GCP Cloud Functions | Azure Functions |
|--------------|------------|---------------------|-----------------|
| **HTTP/API Gateway** | ✅ (API Gateway, ALB, Function URLs) | ✅ (Cloud Endpoints, API Gateway) | ✅ (API Management, HTTP Trigger) |
| **Object Storage** | ✅ (S3) | ✅ (Cloud Storage) | ✅ (Blob Storage) |
| **Database Changes** | ✅ (DynamoDB, RDS) | ✅ (Firestore, BigQuery) | ✅ (Cosmos DB) |
| **Message Queues** | ✅ (SQS) | ✅ (Pub/Sub) | ✅ (Service Bus, Storage Queue) |
| **Streams** | ✅ (Kinesis) | ✅ (Pub/Sub, Kafka) | ✅ (Event Hubs) |
| **Schedule/CRON** | ✅ (EventBridge) | ✅ (Cloud Scheduler) | ✅ (Timer Trigger) |
| **Email** | ✅ (SES) | ✅ (via Pub/Sub) | ✅ (SendGrid) |
| **IoT** | ✅ (IoT Core) | ✅ (IoT Core) | ✅ (IoT Hub) |
| **Git/Code Changes** | ✅ (CodeCommit, GitHub, CodeStar) | ✅ (Cloud Source Repositories, GitHub) | ✅ (GitHub, DevOps, Bitbucket) |

### 2.5 Pricing Comparison

**AWS Lambda Pricing (us-east-1):**
- **Requests:** $0.20 per 1M requests (free tier: 1M/month)
- **Compute (GB-seconds):** $0.0000166667 per GB-second
- **Example (128MB, 100ms, 1M requests):** ~$0.20 (requests) + $0.21 (compute) = $0.41
- **Duration (up to 15 min):** 900,000 ms maximum
- **Free Tier:** 1M requests + 400,000 GB-seconds/month

**GCP Cloud Functions Pricing (us-central1):**
- **Requests:** $0.40 per 1M invocations (free: 2M/month)
- **Compute (GB-seconds):** $0.0000025 per GB-second (1st gen), $0.0000090 (2nd gen)
- **Example (128MB, 100ms, 1M requests):** ~$0.40 (requests) + $0.032 (compute) = $0.432
- **Duration (up to 60 min):** 3,600,000 ms maximum
- **Free Tier:** 2M invocations + 400,000 GB-seconds/month

**Azure Functions Pricing (Consumption Plan):**
- **Requests:** $0.20 per 1M executions (free: 1M/month)
- **Compute (GB-seconds):** $0.000016 per GB-second
- **Example (128MB, 100ms, 1M requests):** ~$0.20 (requests) + $0.204 (compute) = $0.404
- **Duration (up to 10 min):** 600,000 ms maximum
- **Free Tier:** 1M executions + 400,000 GB-seconds/month

### 2.6 Performance Characteristics

| Metric | AWS Lambda | GCP Cloud Functions | Azure Functions |
|--------|------------|---------------------|-----------------|
| **Cold Start (Python)** | ~150ms | ~120ms | ~200ms |
| **Cold Start (Node.js)** | ~100ms | ~80ms | ~150ms |
| **Cold Start (Java)** | ~800ms | ~500ms | ~1000ms |
| **Concurrency Scaling** | ~500-3000 per minute | ~1000 per minute | ~200-500 per minute |
| **Max Concurrent Requests** | 1,000 (default) | 1,000 (default) | 200 (Consumption) |
| **Provisioned Concurrency** | ✅ (pay for kept warm) | ✅ (min instances) | ✅ (Premium plan) |

### 2.7 Observability & Monitoring

| Feature | AWS Lambda | GCP Cloud Functions | Azure Functions |
|---------|------------|---------------------|-----------------|
| **Built-in Logging** | CloudWatch Logs | Cloud Logging | Application Insights |
| **Distributed Tracing** | X-Ray | Cloud Trace | Application Insights |
| **Metrics Dashboard** | CloudWatch | Cloud Monitoring | Azure Monitor |
| **Custom Metrics** | ✅ (EMF) | ✅ | ✅ |
| **Alerting** | CloudWatch Alarms | Cloud Monitoring Alerts | Azure Monitor Alerts |
| **Cost Analysis** | AWS Cost Explorer | Cloud Billing | Cost Management |

### 2.8 Analysis: Choosing for REST API Backend

**For a REST API backend, I would choose AWS Lambda + API Gateway**

**Reasons:**
1. **Maturity:** AWS Lambda is the most mature (2014), with extensive documentation and community
2. **API Gateway integration:** Native, seamless integration with multiple API types (REST, HTTP, WebSocket)
3. **Performance:** Lowest latency for cold starts in production environments (with provisioned concurrency)
4. **Ecosystem:** Largest selection of pre-built Lambda layers and extensions
5. **Cost:** Competitive pricing, especially at scale
6. **Features:** Function URLs (2022) eliminate need for API Gateway for simple APIs

**Alternative choice for specific scenarios:**
- **GCP Cloud Run** (container-based) for microservices with consistent traffic
- **Azure Functions** if already using .NET ecosystem or Microsoft tooling
- **Cloudflare Workers** for edge computing with ultra-low latency (not covered in this lab)

### 2.9 Serverless Advantages & Disadvantages

**Advantages:**
| Advantage | Description |
|-----------|-------------|
| **No Server Management** | Zero infrastructure maintenance, patching, or scaling |
| **Automatic Scaling** | Scales from 0 to thousands of concurrent executions |
| **Pay-per-Use** | No cost when idle, granular billing per execution |
| **Fast Deployment** | Deploy code in seconds, not minutes |
| **Event-Driven** | Native integration with cloud events and triggers |
| **Reduced Time-to-Market** | Focus on code, not infrastructure |

**Disadvantages:**
| Disadvantage | Mitigation |
|--------------|------------|
| **Cold Starts** | Provisioned concurrency, keep-warm strategies, optimization |
| **Execution Time Limits** | Break long-running tasks into steps, use Fargate for >15min |
| **Statelessness** | Use external databases/caches (DynamoDB, Redis, S3) |
| **Vendor Lock-in** | Use containers, abstraction layers, multi-cloud tools |
| **Debugging Complexity** | Use distributed tracing, structured logging, local emulators |
| **Cost at High Scale** | Consider dedicated instances for predictable high traffic |

### 2.10 Comparison Table: Serverless vs Traditional

| Aspect | Serverless (FaaS) | Traditional (VM/Container) |
|--------|-------------------|----------------------------|
| **Scaling** | Automatic, granular | Manual or auto-scaling groups |
| **Cost Model** | Pay per invocation | Pay for provisioned resources |
| **Cold Start** | Yes (100ms-1s) | No (always running) |
| **Max Execution** | 10-60 minutes | Unlimited |
| **State Management** | Stateless | Can be stateful |
| **Deployment Unit** | Function code | Container/VM image |
| **Operation Overhead** | Minimal | Significant |
| **Best For** | Event-driven, sporadic, variable traffic | Consistent high traffic, long-running processes |

---

## References

- AWS Documentation: https://docs.aws.amazon.com/ecr/ (ECR), https://docs.aws.amazon.com/lambda/ (Lambda)
- GCP Documentation: https://cloud.google.com/artifact-registry (Artifact Registry), https://cloud.google.com/functions (Cloud Functions)
- Azure Documentation: https://azure.microsoft.com/services/container-registry/ (ACR), https://azure.microsoft.com/services/functions/ (Functions)

---

## Summary

This lab provided comprehensive research into:
- **Artifact Registries:** AWS ECR/CodeArtifact, GCP Artifact Registry, Azure ACR
- **Serverless Platforms:** AWS Lambda, GCP Cloud Functions, Azure Functions

**Key Takeaways:**
1. Each cloud provider offers robust artifact registry and serverless solutions
2. GCP Artifact Registry has the widest native package format support
3. AWS Lambda is the most mature serverless platform with best cold start performance
4. Azure Functions excels in .NET ecosystem integration
5. Serverless computing reduces operational overhead but introduces constraints
6. Multi-cloud strategies require careful consideration of vendor lock-in

**Final Recommendation for DevOps teams:**
- Use provider-native services for single-cloud strategy
- Implement infrastructure-as-code (Terraform, Pulumi) for multi-cloud flexibility
- Standardize on container-based serverless (Cloud Run, App Runner, Container Apps) for portability
