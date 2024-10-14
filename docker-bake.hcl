// Variables
variable "REPO" { default = "deanayalon/fms" }

group "default" { targets = ["21-0-2-202"] }

// Classes
target "latest" {
    matrix = { devin = [true, false] }
    name = "latest${devin ? "-devin" : ""}"
    tags = [
        "${REPO}:latest${devin ? "-devin" : ""}",   // :latest-devin
        devin ? "${REPO}:devin" : ""                // :devin
    ]
}

// Versions
target "21-0-2-202" {
    matrix = { devin = [true, false] }
    name = "21-0-2-202${devin ? "-devin" : ""}"
    tags = concat(
        devin ? target.latest-devin.tags : target.latest.tags,
        [
            "21${devin ? "-devin" : ""}",
            "21.0${devin ? "-devin" : ""}",
            "21.0.2${devin ? "-devin" : ""}",
            "21.0.2.202${devin ? "-devin" : ""}",
        ]
    )

}