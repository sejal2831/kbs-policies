package policy

import rego.v1

# Temporary policy for testing


default executables := 33
default hardware := 97
default configuration := 36
default file_system := 0
default instance_identity := 0
default runtime_opaque := 0
default storage_opaque := 0
default sourced_data := 0

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

# For sample platform testing
executables := 3 if {
    input.sample
    input.sample.debug == false
}

hardware := 2 if {
    input.sample
}

configuration := 2 if {
    input.sample
    input.sample.debug == false
}
