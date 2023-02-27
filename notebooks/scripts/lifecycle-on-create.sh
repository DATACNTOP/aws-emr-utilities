#!/bin/bash

#set -e
set -eux

echo "Install Extensions ..."
sudo -u ec2-user -i <<'EOF'

source activate JupyterSystemEnv

pip install jupyterlab-lsp
pip install 'python-lsp-server[all]'
jupyter server extension enable --user --py jupyter_lsp

jupyter labextension install jupyterlab-s3-browser
pip install jupyterlab-s3-browser
jupyter serverextension enable --py jupyterlab_s3_browser

# https://github.com/lckr/jupyterlab-variableInspector
pip install lckr-jupyterlab-variableinspector

# https://github.com/matplotlib/ipympl
pip install ipympl

# https://github.com/aquirdTurtle/Collapsible_Headings
pip install aquirdturtle_collapsible_headings

# https://github.com/QuantStack/jupyterlab-drawio
pip install jupyterlab-drawio

sudo systemctl restart jupyter-server
# source deactivate
EOF

echo "Create sh profile  ..."
echo "alias b='/bin/bash'" > ~/.profile

echo "Create custom folder ..."
mkdir -p /home/ec2-user/SageMaker/custom

echo "Download prepareNotebook.sh ..."
wget https://raw.githubusercontent.com/DATACNTOP/aws-emr-utilities/main/notebooks/scripts/prepare-notebook-sagemaker.sh -O /home/ec2-user/SageMaker/custom/prepare-notebook-sagemaker.sh

sudo chmod +x /home/ec2-user/SageMaker/custom/*.sh
sudo chown ec2-user:ec2-user /home/ec2-user/SageMaker/custom/ -R