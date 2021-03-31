#!/bin/sh

while getopts ":m:o:p:" opt; do
  case $opt in
    m) manifest-file-path="$OPTARG";;
    o) output-file-path="$OPTARG";;
    p) pkg-installation-directory-path="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Setting the package installation directory path
export PYTHONPATH=pkg-installation-directory-path
printf "Analysing the stack. Please wait..\n\n"

# Getting stack analysis report using CRDA CLI.
result=$(crda analyse manifest-file-path -j)
exit_code=$?

if [ $exit_code == 1 ]
then
  # In case of failure save only exit code into output file.
  jq -n {} | \
  jq --arg exit_code "$exit_code" '. + {exit_code: $exit_code}' > \
  output-file-path
else
  # In case of success print details from report into console
  printf "=%.0s" {1..40}
  printf "\nCRDA Report.\n"
  printf "=%.0s" {1..40}
  printf "\n"
  printf "Total Scanned Dependencies      :  %s \n" $(jq -r .total_scanned_dependencies <<< $result)
  printf "Scanned Transitive Dependencies :  %s \n" $(jq -r .total_scanned_transitives <<< $result)
  printf "Total Vulnerabilities           :  %s \n" $(jq -r .total_vulnerabilites <<< $result)
  printf "Direct Vulnerable Dependencies  :  %s \n" $(jq -r .direct_vulnerable_dependencies <<< $result)
  printf "Commonly Known Vulnerabilities  :  %s \n" $(jq -r .commonly_known_vulnerabilites <<< $result)
  printf "Vulnerabilities Unique to Synk  :  %s \n" $(jq -r .vulnerabilities_unique_to_synk <<< $result)
  printf "Critical Vulnerabilities        :  %s \n" $(jq -r .critical_vulnerabilities <<< $result)
  printf "High Vulnerabilities            :  %s \n" $(jq -r .high_vulnerabilities <<< $result)
  printf "Medium Vulnerabilities          :  %s \n" $(jq -r .medium_vulnerabilities <<< $result)
  printf "Low Vulnerabilities             :  %s \n" $(jq -r .low_vulnerabilities <<< $result)
  printf "=%.0s" {1..40}
  printf "\n\nOpen this link to see detailed report:\n%s \n\n" $(jq -r .report_link <<< $result)

  # Save report along with exit code into output file.
  jq -n {} | \
  jq --argjson result "$result" '. + {report: $result}' | \
  jq --arg exit_code "$exit_code" '. + {exit_code: $exit_code}' > \
  output-file-path
fi

printf "\nReport is saved into file: output-file-path"
