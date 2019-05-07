# This file is custom to the train-winrm project

#-------------------------------------------------------------#
#                      Components
#-------------------------------------------------------------#

resource "github_issue_label" "component_platform_detection" {
  repository  = "${var.repo_name}"
  name        = "Component/Platform Detection"
  color       = "48bdb9" # aqua
  description = "Identification of the target"
}

resource "github_issue_label" "component_connection_api" {
  repository  = "${var.repo_name}"
  name        = "Component/Connection API"
  color       = "48bdb9" # aqua
  description = "Common things connections do"
}

resource "github_issue_label" "component_options" {
  repository  = "${var.repo_name}"
  name        = "Component/Option Handling"
  color       = "48bdb9" # aqua
  description = "Options and Credentials"
}

resource "github_issue_label" "component_fs_access" {
  repository  = "${var.repo_name}"
  name        = "Component/FS Access"
  color       = "48bdb9" # aqua
  description = "Reading files from the filesystem"
}
resource "github_issue_label" "component_logging" {
  repository  = "${var.repo_name}"
  name        = "Component/Logging"
  color       = "48bdb9" # aqua
  description = "When and what we log"
}

resource "github_issue_label" "component_uuid" {
  repository  = "${var.repo_name}"
  name        = "Component/UUID Generation"
  color       = "48bdb9" # aqua
  description = "Generating unique IDs"
}

