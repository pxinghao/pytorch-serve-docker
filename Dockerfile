FROM python:3.8.2

# Install Java
RUN apt update && apt install -y openjdk-11-jdk

# Install torch and torchserve
RUN pip install torch torchtext torchvision sentencepiece
RUN pip install torchserve

# Create filesystem structures
RUN mkdir /home/model-server
RUN mkdir /home/model-server/model_store

# Copy files over
COPY ./densenet_model_generator.py /home/model-server/
COPY ./index_to_name.json /home/model-server/
COPY ./config.properties /home/model-server/
COPY ./run.sh /home/model-server/
COPY ./create_and_add_model.sh /home/model-server/

# WORKDIR /home/model-server/
# RUN wget https://download.pytorch.org/models/densenet161-8d451a50.pth -P /home/model-server/model_store/

# Create densenet model
# WORKDIR /home/model-server/
# RUN python /home/model-server/densenet_model_generator.py
# RUN torch-model-archiver --model-name densenet161_ts --version 1.0  --serialized-file densenet161.pt --extra-files index_to_name.json --handler image_classifier
# RUN mv densenet161_ts.mar model_store/

# RUN git clone https://github.com/pytorch/serve.git
# WORKDIR /home/model-server/model_store/
# RUN torch-model-archiver --model-name densenet161 --version 1.0 --model-file /home/model-server/serve/examples/image_classifier/densenet_161/model.py --serialized-file /home/model-server/model_store/densenet161-8d451a50.pth --extra-files /home/model-server/serve/examples/image_classifier/index_to_name.json --handler image_classifier

# Prepare to start server
RUN chmod +x /home/model-server/run.sh
EXPOSE 8080 8081

# For creating models
RUN chmod +x /home/model-server/create_and_add_model.sh

# Start server and insert model
CMD ["/home/model-server/run.sh"]