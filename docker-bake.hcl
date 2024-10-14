group "default" {
    targets = ["fms"]
}

target "fms" {
    /* matrix = {
        devin = [true, false]   // Install Devin.fm
        release = [{ 
            fms = string,       // FileMaker Server version
            suffix = string     // FMS suffix (e.g. "_me")
            latest = boolean    // Latest FileMaker Server release
 [-latest] +revision = string   // latest/major/minor/patch/"" 
                              // latest = 21 = 21.0 = 21.0.2 = 21.0.2.202
          
          ubuntu = number,    // Ubuntu base version          
          arm = boolean       // FMS version has an ARM64 release
      }]
    } */
    matrix = {
        devin =[true, false]
        release =[{
            fms = "21.0.2.202", latest = true, suffix = ""
            // revision = "latest"        // latest::21::21.0::21.0.2::21.0.2.202
            ubuntu = 22, arm = true
        }, {
            fms = "21.0.2.207", latest = false, suffix = "_me", // revision = ""
            ubuntu = 22, arm = true       // 21.0.2.207_me
        }, {
            fms = "21.0.1.3", latest = false, suffix = ""
            // revision = "patch"         // 21.0.1::21.0.1.3
            ubuntu = 22, arm = true
        }, {
            fms = "19.6.4.402", latest = false, suffix = "",
            // revision = "major"          // 19::19.6::19.6.4::19.6.4.402
            ubuntu = 20, arm = false
        }]
    }
    dockerfile = "dockerfile.u${release.ubuntu}"
    platforms = ["linux/amd64", release.arm ? "linux/arm64/v8" : ""]

    tags = [
        "deanayalon/fms:${release.fms}${release.suffix}${devin ? "-devin" : ""}",
        // i.e. deanayalon/fms:21.0.2.207_me[-devin]
        release.latest ? "deanayalon/fms:${devin ? ":devin" : ""}" : "",
        // i.e. deanayalon/fms[:devin]

        "ghcr.io/deanayalon/fms:${release.fms}${release.suffix}${devin ? "-devin" : ""}",
        release.latest ? "ghcr.io/deanayalon/fms:${devin ? ":devin" : ""}" : "",
    ]
}