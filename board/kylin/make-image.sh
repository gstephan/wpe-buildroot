#!/bin/bash
#set -x

# these values can be overridden using exports before caling the script
if [ -z ${KERNEL_DEFCONFIG+x} ]; then KERNEL_DEFCONFIG=kylin64_kernel_defconfig;  fi
if [ -z ${KERNEL_OUTPUT_DIR+x} ]; then KERNEL_OUTPUT_DIR=output_kernel;  fi
if [ -z ${ROOTFS_DEFCONFIG+x} ]; then ROOTFS_DEFCONFIG=kylin32hf_wpe_ml_defconfig;  fi
if [ -z ${ROOTFS_OUTPUT_DIR+x} ]; then ROOTFS_OUTPUT_DIR=output_rootfs;  fi
if [ -z ${BUILDROOT_TOP_DIR+x} ]; then BUILDROOT_TOP_DIR=$PWD;  fi
if [ -z ${USB_FLASH_DIR+x} ]; then USB_FLASH_DIR=$BUILDROOT_TOP_DIR/usb_flash;  fi

function print_config(){
	echo "Selected kernel config: $KERNEL_DEFCONFIG"
	echo "Selected kernel output dir: $KERNEL_OUTPUT_DIR"
	echo "Selected rootfs config: $ROOTFS_DEFCONFIG"
	echo "Selected rootfs outdir dir: $ROOTFS_OUTPUT_DIR"
	echo "Selected builtroot dir: $BUILDROOT_TOP_DIR"
	echo "Selected usb flash dir: $USB_FLASH_DIR"
}

function _make(){
	make O=$1 $2
}

function make_all(){
	_make $KERNEL_OUTPUT_DIR $1
	_make $ROOTFS_OUTPUT_DIR $1
}

function config_kernel_build(){
	_make $KERNEL_OUTPUT_DIR $KERNEL_DEFCONFIG
}

function config_rootfs_build(){
	_make $ROOTFS_OUTPUT_DIR $ROOTFS_DEFCONFIG
}

function build_kernel(){
	[ -e $KERNEL_OUTPUT_DIR/.config ] || config_kernel_build
	_make $KERNEL_OUTPUT_DIR all
}

function build_rootfs(){
	[ -e $ROOTFS_OUTPUT_DIR/.config ] || config_rootfs_build
	_make $ROOTFS_OUTPUT_DIR all
}

function print_usage(){
	echo "$0 commands are:"
    echo "    clean      "
    echo "    checkout    "
    echo "    sync        "
    echo "    build       "
    echo "    rescue      "
}

function copy_ko(){
	mkdir -p $ROOTFS_OUTPUT_DIR/target
	tar -xpf $KERNEL_OUTPUT_DIR/images/kernel-modules.tar -C $ROOTFS_OUTPUT_DIR/target
}

function get_image_tools(){
	git clone git@github.com:Metrological/kylin-image.git image
}

function create_image(){
	[ -d image ] || get_image_tools
	# Satisfy Realtek image script 
	if [ -z ${KERNEL_ROOTFS+x} ]; then export KERNEL_ROOTFS=$BUILDROOT_TOP_DIR/$ROOTFS_OUTPUT_DIR/images/rootfs.ext4;  fi
	if [ -z ${KERNEL_DTB_DIR+x} ]; then export KERNEL_DTB_DIR=$BUILDROOT_TOP_DIR/$KERNEL_OUTPUT_DIR/images;  fi
	if [ -z ${KUIMAGE+x} ]; then export KUIMAGE=$BUILDROOT_TOP_DIR/$KERNEL_OUTPUT_DIR/images/Image;  fi
	
    pushd image
       ./build_image.sh clean build
       ERR=$?
    popd

    ERR=$?
    
    return $ERR;
}

function create_usb(){
	mkdir -p $USB_FLASH_DIR
	create_image 
	    
    cp image/image_file/install.img $USB_FLASH_DIR/.
    cp image/image_file/components/tmp/pkgfile/generic/bluecore.audio $USB_FLASH_DIR/.
    cp image/image_file/components/tmp/pkgfile/generic/rescue.root.emmc.cpio.gz_pad.img $USB_FLASH_DIR/.
    cp image/image_file/components/tmp/pkgfile/generic/rescue.emmc.dtb $USB_FLASH_DIR/.
    cp image/image_file/components/tmp/pkgfile/generic/emmc.uImage $USB_FLASH_DIR/.
    cp image/dvrboot.exe.bin $USB_FLASH_DIR/.
}

if [ "$1" = "" ]; then
    print_usage
else
    print_config
    while [ "$1" != "" ]
    do
        case "$1" in
            create)
                create_usb
                ;;
            clean)
                make_all clean
                ;;
            download)
                config_kernel_build
                config_rootfs_build
                make_all source
                ;;
            config)
                config_kernel_build
                config_rootfs_build
                ;;                   
            build)
                build_kernel
                copy_ko
                build_rootfs
                ;;              
            copy)
                copy_ko
                ;;                   
            all)
                build_kernel
                copy_ko
                build_rootfs
                create_image
                ;;
            *)
                echo -e "$0 \033[47;31mUnknown CMD: $1\033[0m"
                print_usage
                exit 1
                ;;
        esac
        shift 1
    done
fi

exit $ERR