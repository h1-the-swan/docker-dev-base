FROM python:3.6

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	zsh \
	vim-gnome

RUN useradd -m --shell /bin/zsh devuser

RUN chsh -s /bin/zsh devuser

WORKDIR /home/devuser

COPY requirements.txt .

COPY ./.vim/ ./.vim
COPY ./.dotfiles/ ./.dotfiles

RUN mkdir .jupyter
COPY ./.jupyter/jupyter_notebook_config.json ./.jupyter/
COPY ./.jupyter/nbconfig ./jupyter/

COPY startup.sh .

RUN chown -R devuser .

USER devuser

ENV PATH=".local/bin:${PATH}"

RUN pip install --user -r requirements.txt --no-warn-script-location

# RUN chmod 777 ./startup.sh
# RUN ["chmod", "+x", "./startup.sh"]

RUN touch ./.zshrc

EXPOSE 8899

ENTRYPOINT ["/bin/zsh", "./startup.sh"]
