
# To list all the OCI compartments name and ocid.
oci iam compartment list --all --query "data[].{Name:name, OCID:id}" --output table


oci network subnet list \
  --compartment-id "$TENANCY_OCID" \
  --all \
  --query 'data[].{Name:"display-name", OCID:id, VCN:"vcn-id", CIDR:"cidr-block"}' \
  --output table
  
  
oci fs file-system list \
  --compartment-id "$TENANCY_OCID" \
  --availability-domain "WUfG:AP-MUMBAI-1-AD-1" \
  --all \
  --query 'data[].{Name:"display-name", OCID:id, Compartment:"compartment-id", AD:"availability-domain"}' \
  --output table
  
  
for cid in $(oci iam compartment list --all --query "data[].id" --raw-output | jq -r '.[]' | tr -d '\r'); do
  echo "=== Compartment: $cid ==="
  oci fs file-system list \
    --compartment-id "$cid" \
    --availability-domain "WUfG:AP-MUMBAI-1-AD-1" \
    --all \
    --query 'data[].{Name:"display-name", OCID:id, Compartment:"compartment-id", AD:"availability-domain"}' \
    --output table
done



# To list all the availability zones

for ad in $(oci iam availability-domain list \
  --compartment-id "$TENANCY_OCID" \
  --query "data[].name" \
  --raw-output | jq -r '.[]'); do
  echo "=== Availability Domain: $ad ==="
  oci fs file-system list \
    --region "$region" \
    --compartment-id "$cid" \
    --availability-domain "$ad" \
    --all \
    --query 'data[].{Name:"display-name", OCID:id, AD:"availability-domain"}' \
    --output table
done




#####

for cid in $(oci iam compartment list --all --query "data[].id" --raw-output | jq -r '.[]' | tr -d '\r'); do
  for region in ap-mumbai-1; do
    echo "=== Compartment: $cid | Region: $region ==="
    
    echo "--- Compute Instances ---"
    oci compute instance list --region "$region" --compartment-id "$cid" --all \
      --query 'data[].{Name:"display-name", OCID:id, Lifecycle:"lifecycle-state"}' --output table
    
    echo "--- Block Volumes ---"
    oci bv volume list --region "$region" --compartment-id "$cid" --all \
      --query 'data[].{Name:"display-name", OCID:id, SizeGB:"size-in-gbs"}' --output table
    
    echo "--- VCNs ---"
    oci network vcn list --region "$region" --compartment-id "$cid" --all \
      --query 'data[].{Name:"display-name", OCID:id, CIDR:"cidr-block"}' --output table
    
    echo "--- Subnets ---"
    oci network subnet list --region "$region" --compartment-id "$cid" --all \
      --query 'data[].{Name:"display-name", OCID:id, CIDR:"cidr-block"}' --output table
    
    echo "--- File Systems ---"
    for ad in $(oci iam availability-domain list \
      --compartment-id "$TENANCY_OCID" \
      --query "data[].name" \
      --raw-output | jq -r '.[]'); do
      echo "=== Availability Domain: $ad ==="
      oci fs file-system list \
        --region "$region" \
        --compartment-id "$cid" \
        --availability-domain "$ad" \
        --all \
        --query 'data[].{Name:"display-name", OCID:id, AD:"availability-domain"}' \
        --output table
    done
    
    echo "--- Object Storage Buckets ---"
    oci os bucket list --region "$region" --compartment-id "$cid" --all \
      --query 'data[].{Name:name, OCID:id}' --output table
 	 
    echo "--- Load Balancers ---"
    oci lb load-balancer list \
      --compartment-id "$cid" \
      --all \
      --region "$region" \
      --query 'data[].{Name:"display-name", OCID:id, Shape:"shape-name", IP:"ip-addresses"[0]."ip-address", State:"lifecycle-state"}' \
      --output table 2>/dev/null || echo "No access or no load balancers in this compartment."
	  
	for ad in $(oci iam availability-domain list \
	  --compartment-id "$cid" \
	  --query 'data[].name' \
	  --raw-output | jq -r '.[]'); do
	
	echo "=== Availability Domain: $ad ==="
	for fs in $(oci fs file-system list \
		--region "$region" \
		--compartment-id "$cid" \
		--availability-domain "$ad" \
		--all \
		--query 'data[].id' \
		--raw-output); do
	
		echo "=== File System: $fs ==="
		oci fs snapshot list \
		--file-system-id "$fs" \
		--all \
		--query 'data[].{Name:"name", OCID:id, TimeCreated:"time-created"}' \
		--output table
	done
	done	  
 	 
    echo
  done
done


# Global command to get the backup policies.
for region in ap-mumbai-1; do
  oci bv volume-backup-policy list --region "$region" --all \
    --query 'data[].{Name:"display-name", OCID:id, Schedules:schedules[]."backup-type"}' \
    --output table
done
  
# ExaCS
oci db exadata-infrastructure list \
  --compartment-id "$TENANCY_OCID" \
  --all \
  --query 'data[?"lifecycle-state"==`AVAILABLE` && "is-cloud-at-customer"==`false`].{Name:"display-name", OCID:id, Shape:shape, Lifecycle:"lifecycle-state"}' \
  --output table