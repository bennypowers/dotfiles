function makekernel -d "build and install custom kernel for raspberry pi 5 gentoo"
  cd /opt/src/linux
  make -j4 Image.gz modules dtbs
  sudo mount /boot
  sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/
  sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
  sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
  sudo cp arch/arm64/boot/Image.gz /boot/kernel_2712.img
end
