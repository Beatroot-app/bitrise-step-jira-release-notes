#!/bin/bash
set -ex

echo "Installing required deppendencies"
pip3 install --no-cache-dir requests argparse

echo "Executing jira-release-notes"

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COMMAND=$(cat << EOF
python3 $THIS_SCRIPT_DIR/jira-release.py \
    -v ${version_name} \
    -p ${projectId} \
    -u ${user} \
    --password ${password} \
    --url ${url} \
    --format ${format}
EOF
)

if [ "${skip_output_intro}" == "true" ] && [ ! -z "${skip_output_intro}" -a "${skip_output_intro}" != " " ]; then
    COMMAND="$COMMAND --skip-output-intro"
fi

if [ "${skip_output_intro_version_name}" == "true" ] && [ ! -z "${skip_output_intro_version_name}" -a "${skip_output_intro_version_name}" != " " ]; then
    COMMAND="$COMMAND --skip-output-intro-version-name"
fi

if [ "${skip_output_intro_issues_count}" == "true" ] && [ ! -z "${skip_output_intro_issues_count}" -a "${skip_output_intro_issues_count}" != " " ]; then
    COMMAND="$COMMAND --skip-output-intro-issues-count"
fi

if [ "${skip_output_issue_type_title}" == "true" ] && [ ! -z "${skip_output_issue_type_title}" -a "${skip_output_issue_type_title}" != " " ]; then
    COMMAND="$COMMAND --skip-output-issue-type-title"
fi

if [ "${skip_newline_between_issue_types}" == "true" ] && [ ! -z "${skip_newline_between_issue_types}" -a "${skip_newline_between_issue_types}" != " " ]; then
    COMMAND="$COMMAND --skip-newline-between-issue-types"
fi

eval $COMMAND | envman add --key JIRA_RELEASE_NOTES