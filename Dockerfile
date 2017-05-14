FROM daocloud.io/leeonky/os-dev:master-22991dc

USER root

###### install docker client
RUN install-docker

###### install vim extended
RUN yum -y install vim-common vim-enhanced vim-filesystem

###### VIM plugins
USER $USER_NAME
ADD vimrc $USER_HOME/.vimrc
ADD vimrc.d $USER_HOME/.vimrc.d
RUN sudo yum -y install git && \
	sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc && \
	sudo chown $USER_NAME:$USER_NAME $USER_HOME/.vimrc.d -R && \
	/bin/bash --login $USER_HOME/.vimrc.d/vim_install.sh
