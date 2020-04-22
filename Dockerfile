FROM python:3.8.2

# Install Java
RUN apt-get update && apt-get install -y openjdk-11-jdk

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
COPY ./kitten.jpg /home/model-server/

# Prepare to start server
RUN chmod +x /home/model-server/run.sh
EXPOSE 8080 8081

# For creating models
RUN chmod +x /home/model-server/create_and_add_model.sh

# Start server and insert model
CMD ["/home/model-server/run.sh"]