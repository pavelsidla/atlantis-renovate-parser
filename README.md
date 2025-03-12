# Atlantis Renovate parser

## Overview
This script retrieves the latest Atlantis Terraform plan statuses from a specified GitHub repository branch and displays them in a formatted table. It uses the GitHub CLI (`gh`) to fetch commit statuses and filters for Atlantis plan results that indicate infrastructure changes.

## Prerequisites
- GitHub CLI (`gh`) installed and authenticated
- `jq` installed for JSON processing
- macOS (if using the `open` command to open URLs)

## Usage
```sh
./script.sh -o <owner> -r <repo> -b <branch> [-O]
```

### Arguments
| Flag   | Description                                     |
|--------|------------------------------------------------|
| `-o`   | GitHub repository owner (organization/user)   |
| `-r`   | GitHub repository name                        |
| `-b`   | Branch name to check                          |
| `-O`   | (Optional) Open plan URLs in the browser      |

## Example
```sh
./script.sh -o my-org -r my-repo -b main
```
This will retrieve and display the Terraform plan statuses for the latest commit in the `main` branch of `my-org/my-repo`.

To automatically open URLs in the browser:
```sh
./script.sh -o my-org -r my-repo -b main -O
```

## Output Format
The script prints the results in a table format:
```
Terraform Plan                                  | Changes                       | URL
----------------------------------------------------------------------------------------------------
project1/plan                                   | 2 to add, 1 to change        | https://github.com/.../checks
project2/plan                                   | 5 to add, 3 to destroy       | https://github.com/.../checks
```

## How It Works
1. Retrieves the latest commit SHA from the specified branch.
2. Fetches commit statuses and filters for Atlantis Terraform plans.
3. Displays the results in a structured table.
4. If `-O` is used, opens URLs in the default web browser.

## Notes
- Ensure you have the necessary permissions to access the repository.
- This script relies on GitHub Actions statuses; make sure Atlantis runs within your CI/CD pipeline.
- The script paginates results if there are multiple pages of statuses.

## License
This script is open-source and can be modified as needed.