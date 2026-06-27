#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
# Tip: Ensure $username and $token are exported in your environment, 
# or replace these with actual values/variables.
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Check if arguments are provided
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list ALL collaborators on the repository
function list_all_collaborators {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators and format as "username (role)"
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | "\(.login) (role: \(.role_name))"')"

    # Display the list of collaborators
    if [[ -z "$collaborators" || "$collaborators" == *"null"* ]]; then
        echo "No collaborators found or unable to fetch details for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Collaborators for ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "Listing all collaborators for ${REPO_OWNER}/${REPO_NAME}..."
list_all_collaborators
