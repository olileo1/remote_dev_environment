FROM continuumio/anaconda3:latest

# Install Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Set personal git configuration
RUN git config --global user.email "user.name@mail.com"
RUN git config --global user.name "gituser"

# Copy config files
COPY /conda_envs/ /home/conda_envs/
COPY README.md /home/README.md

WORKDIR /home/

# Initialize conda and create conda environments
RUN conda init bash
RUN conda install nb_conda_kernels pandas numpy scipy
RUN conda env create -f conda_envs/conda_env.yml
RUN conda env create -f conda_envs/conda_r_env.yml

# Start the code-server
ENTRYPOINT [ "code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080" ]