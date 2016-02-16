#!/bin/bash

# Copyright (c) 2014-2016 Du Huanpeng<u74147@gmail.com>
# place this file to tkernel_source/


export BD=${PWD}
export GNU_BD="/opt/gcc-arm/bin/.."
export GNUarm_2="/opt/gcc-arm/arm-none-eabi/../."
export BUILD_TARGET="tef_em1d"

alias bd='cd ${BD}'
alias tk='cd ${BD}"/kernel/sysmain/build/tef_em1d/"'
alias tm='cd ${BD}"/monitor/tmmain/build/tef_em1d/"'
alias ro='cd ${BD}"/config/build/tef_em1d/"'

tkernel-prepare-gcc ()
{
	CROSS=${1}
	ln -s ${CROSS}ar ar
	ln -s ${CROSS}objcopy arm_2-unknown-tkernel-objcopy
	ln -s ${CROSS}gcc gcc4arm
	ln -s ${CROSS}nm  nm
	ln -s ${CROSS}ranlib  ranlib
}

tkernel-build-all ()
{
	cd ${BD}

	make -C kernel/sysmain/build/tef_em1d/
	make -C config/build/tef_em1d/
	make -C monitor/tmmain/build/tef_em1d/
}

make-source-from-object ()
{
	nm ${1} >map

	sed "s/^.* [^T] .*$//g" map >tmp1
	sed '/^\s*$/d' tmp1 >tmp2
	sed "s/^.*T\s//g" tmp2 >tmp3

	tmpfiles="tmp1 tmp2 tmp3"

	L='IMPORT\s*[a-zA-Z_]*\s'
	R='(.*)\s*;' 

	for func in `cat tmp3`
	do
		P="${L}""${func}""${R}"

		find -name "*.h" -exec grep "${P}" {} \;
	done

	if [ -n "${2}" ]; then
		rm -f ${tmpfiles}
	fi
}

