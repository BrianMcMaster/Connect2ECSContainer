Connect to ECS container
==

Requires
- aws-cli - https://aws.amazon.com/cli/
- jq - https://stedolan.github.io/jq/

Configure path to your ECS SSH key file ~/.bashrc

    echo 'export ECS_PEM_FILE=$HOME/docker.pem' >> ~/.bashrc
    . ~/.bashrc
    
Run

    ecs-console cluster-name service-name
