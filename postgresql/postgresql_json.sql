CREATE TABLE terraform_state (
    id SERIAL PRIMARY KEY,
    version INT,
    terraform_version VARCHAR(20),
    serial INT,
    lineage UUID,
    outputs JSONB,
    resources JSONB
);


INSERT INTO terraform_state (
    version,
    terraform_version,
    serial,
    lineage,
    outputs,
    resources
) VALUES (
    4,
    '1.6.5',
    6,
    'ce79255a-d2e9-6bea-b8cd-f488fc568017',
    '{}',
    CAST('[{
        "mode": "managed",
        "type": "aws_instance",
        "name": "bastion",
        "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
        "instances": [
            {
                "schema_version": 1,
                "attributes": {
                    "ami": "ami-079db87dc4c10ac91",
                    "arn": "arn:aws:ec2:us-east-1:705589761562:instance/i-053c1c9635155b191",
                    "subnet_id": "subnet-06a61490634cc8757",
                    "tags": {
                        "Name": "Bastion-Server"
                    },
                    "tenancy": "default",
                    "vpc_security_group_ids": ["sg-05f909624d0cc501c"]
                },
                "sensitive_attributes": [],
                "private": "{\"e2bfb730-ecaa-11e6-8f88-34363bc7c4c0\":{\"create\":600000000000,\"delete\":6000000000000}}",
                "mode": "managed",
                "type": "aws_instance",
                "name": "bastion",
                "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]"
            }
        ]
    }]' AS JSONB)
);


-- Extracting specific fields from the JSONB resources column
SELECT
    version,
    terraform_version,
    serial,
    lineage,
    outputs,
    resources->0->>'mode' AS mode,
    resources->0->>'type' AS resource_type,
    resources->0->'instances'->0->'attributes'->>'ami' AS ami
FROM
    terraform_state;
