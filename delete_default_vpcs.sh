
#!/bin/bash
set -euo pipefail

function main() {
    if ! aws --version &>/dev/null; then
        echo "Please install aws cli"
        exit 1
    fi

    dry_run=false
    async=true

    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
        --dry-run)
            export dry_run=true
            shift
            ;;
        --no-async)
            async=false
            shift
            ;;
        *)
            print_help
            shift
            exit 1
            ;;
        esac
    done

    pids=()
    regions=$(aws ec2 describe-regions \
        --query 'Regions[].RegionName | sort(@)' \
        --output text)
    if $async; then
        for region in $regions; do
            delete_default_vpc "$region" &
            pids+=($!)
        done
        for pid in "${pids[@]}"; do
            wait "$pid" || echo "failed job PID=$pid"
        done
    else
        for region in $regions; do
            delete_default_vpc "$region"
        done
    fi
}

function print_help() {
    cat <<EOF
usage: $0 [--help] [--dry-run] [--no-async]
optional arguments:
  -h, --help        show this help message and exit
  --dry-run         only print, dont delete anything
  --no-async        don't run in regions asynchronously
EOF
}

function delete_subnet() {
    local region=$1
    local subnet=$2
    if $dry_run; then
        echo "Would have deleted subnet $subnet in $region"
    else
        aws ec2 delete-subnet \
            --region "$region" \
            --subnet-id "$subnet"
    fi
}

function delete_subnets() {
    local region=$1
    local vpc=$2

    subnets=$(aws ec2 describe-subnets \
        --region "$region" \
        --filters "Name=vpcId,Values=$vpc" \
        --query 'Subnets[].SubnetId' \
        --output text)

    for subnet in $subnets; do
        delete_subnet "$region" "$subnet"
    done
}

delete_igw() {
    local region=$1
    local vpc=$2
    local igw=$3
    if $dry_run; then
        echo "Would have deleted Internet GW $igw in $region"
    else
        aws ec2 detach-internet-gateway \
            --region "$region" \
            --internet-gateway-id "$igw" \
            --vpc-id "$vpc"
        aws ec2 delete-internet-gateway \
            --region "$region" \
            --internet-gateway-id "$igw"
    fi
}

function delete_igws() {
    local region=$1
    local vpc=$2

    igws=$(aws ec2 describe-internet-gateways \
        --region "$region" \
        --filters "Name=attachment.vpc-id,Values=$vpc" \
        --query 'InternetGateways[].InternetGatewayId' \
        --output text)

    for igw in $igws; do
        delete_igw "$region" "$vpc" "$igw"
    done
}

function delete_vpc() {
    local region=$1
    local vpc=$2

    # In case a subnet is in use we don't want to delete the igw.
    delete_subnets "$region" "$vpc"
    delete_igws "$region" "$vpc"
    if $dry_run; then
        echo "Would have deleted VPC $vpc in $region"
    else
        aws ec2 delete-vpc \
            --region "$region" \
            --vpc-id "$vpc"
        echo "Removed default VPC $vpc in $region"
    fi
}

function delete_default_vpc() {
    local region=$1
    vpc=$(aws ec2 describe-vpcs \
        --region "$region" \
        --filters "Name=isDefault,Values=true" \
        --query "Vpcs[].VpcId" \
        --output text)

    if [ "$vpc" == "" ]; then
        echo "No default VPC in $region"
    else
        delete_vpc "$region" "$vpc"
    fi
}

main "$@"