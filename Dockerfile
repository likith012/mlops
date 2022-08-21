
FROM ubuntu:22.04

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get update && apt-get install -y wget nano

WORKDIR /root

RUN cd /root \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && sh Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 


RUN /bin/bash -c "source /root/.bashrc \
    && conda create -y -n mlops python=3.9"
RUN conda init bash

RUN echo 'conda activate mlops' >> ~/.bashrc

# COPY . mlops

RUN /bin/bash -c "source ~/.bashrc \
    # && cd mlops \
    && source activate mlops"

RUN pip install Flask==2.2.2 \
        ipykernel==6.15.1 \
        ipython==8.4.0 \
        Jinja2==3.1.2 \
        jupyter-client==7.3.4 \
        jupyter-core==4.11.1 \
        numpy==1.23.2 \
        pandas==1.4.3 \
        tensorboard==2.9.1 \
        tensorflow==2.9.1 \
        tensorflow-hub==0.12.0 \
        tensorflow-text==2.9.0


COPY . mlops

CMD ["/bin/bash"]