variable "MAJOR" {      default = 21 }
variable "MINOR" {      default = 0 }
variable "PATCH" {      default = 2 }
variable "REVISION" {   default = 202 }
variable "LOCALE" {     default = "us" }
variable "UBUNTU" {     default = 22 }
variable "ARM" {        default = true }

variable "LATEST" {     default = "latest" }    // latest > major > minor > patch > revision
// This variable defines the tag levels the image will get
    // ex. version = 21.0.2.202
        // latest -     latest::21::21.0::21.0.2::21.0.2.202
        // major -      21::21.0::21.0.2::21.0.2.202
        // minor -      21.0::21.0.2::21.0.2.202
        // patch -      21.0.2::21.0.2.202
        // revision -   21.0.2.202