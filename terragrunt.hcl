# Manage repository pathes
locals {
  repo_location = join("/", [element(split("/", get_repo_root()), length(split("/", get_repo_root())) - 3), get_path_from_repo_root()])
}
