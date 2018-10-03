FROM python:3.6

ARG myhomedir

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	zsh \
	vim-gnome

RUN useradd -m --shell /bin/zsh devuser

RUN chsh -s /bin/zsh devuser

WORKDIR /home/devuser

COPY startup.sh .

# RUN chmod 777 ./startup.sh
RUN ["chmod", "+x", "./startup.sh"]

USER devuser

ENV PATH=".local/bin:${PATH}"

COPY requirements.txt .

RUN pip install --user -r requirements.txt

EXPOSE 8888

ENTRYPOINT ["/bin/zsh", "startup.sh"]
