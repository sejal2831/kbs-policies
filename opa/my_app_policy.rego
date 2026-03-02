package policy

import rego.v1

# Custom Policy for My Confidential Application
# Inspired by SCONE's security model
# 
# This policy validates:
# 1. Container image names (like SCONE service definitions)
# 2. Security configuration (debug disabled)
# 3. Platform measurements (like SCONE's MRENCLAVE checks)

# Default trust claims (conservative - deny by default)
default executables := 33  # Not recognized
default hardware := 97     # Should be recognized but isn't
default configuration := 36 # Unavailable
default file_system := 0
default instance_identity := 0
default runtime_opaque := 0
default storage_opaque := 0
default sourced_data := 0

# Main trust claims structure
trust_claims := {
    "executables": executables,
    "hardware": hardware,
    "configuration": configuration,
    "file-system": file_system,
    "instance-identity": instance_identity,
    "runtime-opaque": runtime_opaque,
    "storage-opaque": storage_opaque,
    "sourced-data": sourced_data,
}

##### Sample Platform (for testing without SGX hardware)

# Executables trust claim = 3 (approved executables loaded)
executables := 3 if {
    input.sample
    input.sample.debug == false
    
    # Check launch digest matches reference value
    input.sample.launch_digest in query_reference_value("my_app_launch_digest")
}

# Hardware trust claim = 2 (genuine hardware verified)
hardware := 2 if {
    input.sample
    
    # Check security version number
    input.sample.svn in query_reference_value("my_app_svn")
    
    # Check platform version
    input.sample.platform_version.major == query_reference_value("platform_major")
    input.sample.platform_version.minor >= query_reference_value("platform_minor")
}

# Configuration trust claim = 2 (known and approved config)
configuration := 2 if {
    input.sample
    
    # Debug must be disabled (SCONE-style security requirement)
    input.sample.debug == false
    
    # Container image must be approved (SCONE-style service check)
    approved_container_image
}

##### Helper Functions

# Check if container image is in approved list
approved_container_image if {
    # Get container from init_data claims
    some container in input.init_data_claims.agent_policy_claims.containers
    
    # Extract image name
    image_name := container.OCI.Annotations["io.kubernetes.cri.image-name"]
    
    # Check against approved images (from reference values)
    image_name in query_reference_value("approved_images")
}

##### Extensions (Custom metadata about the workload)

extensions := [
    {
        "name": "custom.my_app.policy",
        "key": -19,
        "value": {
            "policy_id": "my_app_policy",
            "policy_version": "1.0.0",
            "description": "Custom policy for my confidential application",
            "validated_claims": validated_claims
        }
    }
]

# Extract validated claims from the workload
validated_claims := {
    "container_images": container_images,
    "debug_disabled": debug_status,
}

# Get list of container images from the workload
container_images := [img |
    container := input.init_data_claims.agent_policy_claims.containers[_]
    img := container.OCI.Annotations["io.kubernetes.cri.image-name"]
]

# Check debug status
debug_status := input.sample.debug if {
    input.sample
} else := "unknown"
