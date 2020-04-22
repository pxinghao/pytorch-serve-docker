#!/bin/bash

pip install torch-model-archiver

# Create densenet model archive
python /home/model-server/densenet_model_generator.py
torch-model-archiver --model-name densenet161 --version 1.0  --serialized-file densenet161.pt --extra-files index_to_name.json --handler image_classifier
mv densenet161.mar model_store/
rm densenet161.pt

# Add model
curl -X POST "http://127.0.0.1:8081/models?initial_workers=1&synchronous=true&url=densenet161.mar"

# Test model
curl -X POST "http://127.0.0.1:8080/predictions/densenet161" -T kitten.jpg
