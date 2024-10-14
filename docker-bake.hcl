variable "REPO" { default = "deanayalon/fms" }
variable "LATEST" {     default = "latest" }    // latest/major/minor/patch/revision        latest::21::21.0::21.0.2::21.0.2.202
variable "MAJOR" {      default = 21 }
variable "MINOR" {      default = 0 }
variable "PATCH" {      default = 2 }
variable "REVISION" {   default = 202 }
variable "LOCALE" {     default = "us" }        // us/eu/me
variable "UBUNTU" {     default = 22 }          // 22/20
variable "ARM" {        default = true }        // Does the FMS version have an ARM64 release?

group "default" { targets = ["fms"] }

target "fms" {
    matrix = { devin = [true, false] }
    name = "fms${devin ? "-devin" : ""}"
    dockerfile = "dockerfile.u${UBUNTU}"
    tags = concat(
        LATEST == "latest" ? [
            "${REPO}:${LOCALE}${devin ? "-devin" : ""}",                                                    // :us[-devin]    
            "${REPO}:latest_${LOCALE}${devin ? "-devin" : ""}",                                             // :latest_us[-devin]
            LOCALE == "us" ? "${REPO}${devin ? ":devin" : ""}" : "",                                        // :devin               (us)
            LOCALE == "us" && devin ? "${REPO}:latest-devin" : "",                                          // :latest-devin        (us, devin)
        ] : [],
        LATEST == "latest" || LATEST == "major" ? [
            "${REPO}:${MAJOR}_${LOCALE}${devin ? "-devin" : ""}",                                           // :21_us[-devin]
            LOCALE == "us" ? "${REPO}:${MAJOR}${devin ? "-devin" : ""}" : ""                                // :21[-devin]          (us)
        ] : [],
        LATEST == "latest" || LATEST == "major" || LATEST == "minor" ? [
            "${REPO}:${MAJOR}.${MINOR}_${LOCALE}${devin ? "-devin" : ""}",                                  // :21.0_us[-devin]
            LOCALE == "us" ? "${REPO}:${MAJOR}.${MINOR}${devin ? "-devin" : ""}" : ""                       // :21.0[-devin]        (us)
        ] : [],
        LATEST == "latest" || LATEST == "major" || LATEST == "minor" || LATEST == "patch" ? [
            "${REPO}:${MAJOR}.${MINOR}.${PATCH}_${LOCALE}${devin ? "-devin" : ""}",                         // :21.0.2_us[-devin]
            LOCALE == "us" ? "${REPO}:${MAJOR}.${MINOR}.${PATCH}${devin ? "-devin" : ""}" : ""              // :21.0.2[-devin]      (us)
        ] : [], [
            "${REPO}:${MAJOR}.${MINOR}.${PATCH}.${REVISION}_${LOCALE}${devin ? "-devin" : ""}",             // :21.0.2.202_us[-devin]
            LOCALE == "us" ? "${REPO}:${MAJOR}.${MINOR}.${PATCH}.${REVISION}${devin ? "-devin" : ""}": ""   // :21.0.2.202[-devin]  (us)
        ]
    )
    platforms = ["linux/amd64", ARM ? "linux/arm64/v8" : ""]
}