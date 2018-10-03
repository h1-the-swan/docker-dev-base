FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	zsh \
	vim-gnome

RUN useradd -m --shell /bin/zsh devuser

RUN chsh -s /bin/zsh devuser

WORKDIR /home/devuser

COPY ./devuser/ ./

USER devuser

ENV PATH=".local/bin:${PATH}"

COPY requirements.txt .

RUN pip install --user -r requirements.txt --no-warn-script-location

COPY startup.sh .

# RUN chmod 777 ./startup.sh
# RUN ["chmod", "+x", "./startup.sh"]

EXPOSE 8899

RUN ls -lha

ENTRYPOINT ["/bin/zsh", "./startup.sh"]
