#!/bin/sh

echo "Cloning repositories..."

CODE=$HOME/code
WORK=$CODE/intellistack
JMAT=$CODE/jerrodmathis

# Intellistack
git clone git@github.com:formstack/odin-ui.git $WORK/odin-ui
git clone git@github.com:formstack/odin-workflows.git $WORK/odin-workflows
git clone git@github.com:formstack/daedalus.git $WORK/daedalus

# My repositories
git clone git@github.com:jerrodmathis/live-pull-requests.git $JMAT/live-pull-requests

