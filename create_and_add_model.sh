#!/bin/bash

pip install torch-model-archiver

# Create densenet model archive
python /home/model-server/densenet_model_generator.py
torch-model-archiver --model-name densenet161_ts --version 1.0  --serialized-file densenet161.pt --extra-files index_to_name.json --handler image_classifier
mv densenet161_ts.mar model_store/
rm densenet161.ts

# Add model
curl -X POST http://127.0.0.1:8081/models?url=densenet161.mar&initial_workers=1

