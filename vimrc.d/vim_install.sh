install_plugin() {
	local file=$1
	cd ~/.vim/bundle
	local url=$(grep '^"' $file | head -n 1 | sed 's/^"//g')
	if [ "$url" != "" ]; then
		git clone $url && mv $file ${file%.in}
	fi
}

install_plugins() {
	mkdir -p ~/.vim/bundle

	for file in `find ~/.vimrc.d/ -name '*.vimrc.in'` 
	do
		install_plugin $file || return 1
	done

	rm ~/.vim/bundle/*/.git* -rf
}

install_plugins
