# KBS Policies Repository

This repository contains OPA (Open Policy Agent) policies and reference values for the Key Broker Service (KBS).

## Structure
```
policies/
├── opa/                      # Rego policy files
│   └── my_app_policy.rego   # Custom application policy
├── reference-values/         # Expected measurements
│   └── my_app_values.json   # Reference values for my app
└── README.md                # This file
```

## Policy: my_app_policy

**Purpose:** Validate confidential workloads before granting access to secrets

**Checks performed:**
1. ✅ Container image is in approved list
2. ✅ Debug mode is disabled
3. ✅ Launch digest matches expected value
4. ✅ Security Version Number (SVN) is acceptable
5. ✅ Platform version meets minimum requirements

**Approved Images:**
- `my-confidential-app:v1.0`
- `my-confidential-app:latest`
- `docker.io/my-app:v1.0`

## Reference Values

Reference values define the expected measurements and configurations:

- `my_app_launch_digest`: Expected launch measurements
- `my_app_svn`: Accepted security version numbers (1, 2)
- `platform_major`: Required platform major version (1)
- `platform_minor`: Minimum platform minor version (0)
- `approved_images`: List of allowed container images

## Usage

KBS fetches policies from this repository and evaluates workload attestations against these rules.

**Author:** Sejal Manoj Utekar  
**Project:** KBS Operator - TU Dresden  
**Date:** March 2, 2026
