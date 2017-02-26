FROM alpine:3.4

RUN apk add  --update wget ca-certificates \
  git \
  build-base gcc abuild binutils \
  cmake 

ADD trigger /tmp/bogus

RUN export KERNELVER=`uname -r  | cut -d '-' -f 1`  && \
  export KERNELDIR=/linux-$KERNELVER && \
  wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVER.tar.gz && \
  tar zxf linux-$KERNELVER.tar.gz && \
  cd linux-$KERNELVER && \
  zcat /proc/1/root/proc/config.gz > .config && \
  sed -i 's/# CONFIG_SQUASHFS is not set/CONFIG_SQUASHFS=m/' .config && \
  yes ""|make oldconfig && \
  make modules_prepare && \
  make SUBDIRS=fs/squashfs modules && \
  cp /linux-4.9.6/fs/squashfs/squashfs.ko /tmp && \
  rm -rf /linux-4.9.6

CMD ["insmod","/tmp/squashfs.ko" ]
