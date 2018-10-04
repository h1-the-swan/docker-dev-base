FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	zsh \
	vim-gnome

RUN useradd -m --shell /bin/zsh devuser

RUN chsh -s /bin/zsh devuser

WORKDIR /home/devuser

COPY ./code/requirements.txt .

COPY ./setup/.vim/ ./.vim
COPY ./setup/.dotfiles/ ./.dotfiles

RUN mkdir .jupyter
COPY ./setup/.jupyter/jupyter_notebook_config.json ./.jupyter/
COPY ./setup/.jupyter/nbconfig ./jupyter/

COPY ./setup/startup.sh .

RUN chown -R devuser .

USER devuser

ENV PATH=".local/bin:${PATH}"

RUN pip install --user -r requirements.txt --no-warn-script-location

# RUN chmod 777 ./startup.sh
# RUN ["chmod", "+x", "./startup.sh"]

RUN touch ./.zshrc

EXPOSE 8899

ENTRYPOINT ["/bin/zsh", "./startup.sh"]
