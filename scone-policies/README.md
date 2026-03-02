# KBS Policies Repository (SCONE-style)

This repository contains SCONE-inspired YAML security policies (SPOLs) for KBS.

## Structure
```
policies/
├── sessions/
│   ├── my-app-session.yaml      # SCONE-style session/policy
│   └── reference-values.yaml    # Expected measurements
└── README.md
```

## SCONE-Style Session Format

Based on: https://sconedocs.github.io/example_policy/

### Session Components:

1. **Services**: Define confidential containers
   - Image names
   - MRENCLAVEs (measurements)
   - Environment variables
   - Secret bindings

2. **Secrets**: Define available secrets
   - Database credentials
   - API keys
   - Certificates

3. **Security Requirements**:
   - Attestation required
   - Debug disabled
   - Approved images only

## Usage with KBS

KBS will fetch these YAML policies from Git and validate workloads against them.

**Author:** Sejal Manoj Utekar  
**Date:** March 2, 2026
