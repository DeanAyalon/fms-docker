// Variables
variable "REPO" { default = "deanayalon/fms" }
variable "LATEST" {     default = "latest" }    // latest/major/minor/patch/revision        latest::21::21.0::21.0.2::21.0.2.202
variable "MAJOR" {      default = 21 }
variable "MINOR" {      default = 0 }
variable "PATCH" {      default = 2 }
variable "REVISION" {   default = 202 }
// variable "LOCALE" {     default = "us" }

group "default" { targets = ["fms"] }

target "fms" {
    matrix = { devin = [true, false] }
    name = "fms${devin ? "-devin" : ""}"
    tags = concat(
        LATEST == "latest" ? [
            "${REPO}:latest${devin ? "-devin" : ""}",                                   // :latest[-devin]
            devin ? "${REPO}:devin" : ""                                                // :devin    
        ] : [],
        LATEST == "latest" || LATEST == "major" ? [
            "${REPO}:${MAJOR}${devin ? "-devin" : ""}"                                  // :21[-devin]
        ] : [],
        LATEST == "latest" || LATEST == "major" || LATEST == "minor" ? [
            "${REPO}:${MAJOR}.${MINOR}${devin ? "-devin" : ""}"                         // :21.0[-devin]
        ] : [],
        LATEST == "latest" || LATEST == "major" || LATEST == "minor" || LATEST == "patch" ? [
            "${REPO}:${MAJOR}.${MINOR}.${PATCH}${devin ? "-devin" : ""}"                // :21.0.2[-devin]
        ] : [], [
            "${REPO}:${MAJOR}.${MINOR}.${PATCH}.${REVISION}${devin ? "-devin" : ""}"    // :21.0.2.202[-devin]
        ]
    )

}