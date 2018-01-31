FROM leeonky/os-dev:ubuntu

USER $USER_NAME

###### install vim extended
RUN sudo apt-get update && sudo apt-get install -y \
	vim vim-common vim-nox && \
	sudo apt-get clean

###### markdown plugin
RUN sudo apt-get -y install nodejs npm xdg-utils firefox fonts-wqy-microhei && \
	sudo apt-get clean && \
	sudo npm -g install instant-markdown-d

###### VIM plugins
USER $USER_NAME
ADD vimrc $USER_HOME/.vimrc
ADD vimrc.d $USER_HOME/.vimrc.d
RUN sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc && \
	sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc.d -R && \
	/bin/bash --login $USER_HOME/.vimrc.d/vim_install.sh
