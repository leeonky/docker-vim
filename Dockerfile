FROM daocloud.io/leeonky/os-dev:master-22991dc

USER $USER_NAME

###### install vim extended
RUN sudo yum -y install vim-common vim-enhanced vim-filesystem

###### markdown plugin
RUN sudo yum -y install nodejs xdg-utils firefox wqy-microhei-fonts
RUN sudo npm -g install instant-markdown-d

###### VIM plugins
USER $USER_NAME
ADD vimrc $USER_HOME/.vimrc
ADD vimrc.d $USER_HOME/.vimrc.d
RUN sudo yum -y install git && \
	sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc && \
	sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc.d -R && \
	/bin/bash --login $USER_HOME/.vimrc.d/vim_install.sh
