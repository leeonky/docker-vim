FROM daocloud.io/leeonky/centos-7

USER root

###### install docker client
RUN yum -y install docker

###### install vim extended
RUN yum -y install vim-common vim-enhanced vim-filesystem

###### tools for install plugin
ADD vimrc $USER_HOME/.vimrc
ADD vimrc.d $USER_HOME/.vimrc.d
RUN yum -y install git && \
	/bin/bash --login $USER_HOME/.vimrc.d/vim_install.sh && \
	sudo rm -f $USER_HOME/.vimrc.d/vim_install.sh
