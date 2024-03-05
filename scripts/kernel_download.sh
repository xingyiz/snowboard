KERNEL_SRC=$KERNEL_DIR/source/
if [ ! -d "$KERNEL_SRC" ]; then
	cd $KERNEL_DIR > /dev/null
	mkdir $KERNEL_SRC
	wget https://github.com/torvalds/linux/archive/refs/tags/v6.8-rc6.tar.gz
	tar -zxvf v6.8-rc6.tar.gz -C $KERNEL_SRC --strip-components 1
	rm v6.8-rc6.tar.gz
fi
