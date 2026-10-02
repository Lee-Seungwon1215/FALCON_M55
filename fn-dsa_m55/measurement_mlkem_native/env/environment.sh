# Source this file to enter the isolated, pinned M55 build environment.
# No hardware operations, global installation, or board-specific environment
# variables are performed by this file.
export FNDSA_M55_ENV=/Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/env
export ZEPHYR_BASE="$FNDSA_M55_ENV/zephyr-4.4.1"
export ZEPHYR_CMSIS_6_MODULE="$FNDSA_M55_ENV/cmsis_6"
export ZEPHYR_HAL_STM32_MODULE="$FNDSA_M55_ENV/hal_stm32"
export ZEPHYR_MODULES="$ZEPHYR_CMSIS_6_MODULE;$ZEPHYR_HAL_STM32_MODULE"
export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
export GNUARMEMB_TOOLCHAIN_PATH="$FNDSA_M55_ENV/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi"
export MLKEM_NATIVE_PINNED_ROOT="$FNDSA_M55_ENV/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f"
export VIRTUAL_ENV="$FNDSA_M55_ENV/build-venv"
export PATH="$VIRTUAL_ENV/bin:$GNUARMEMB_TOOLCHAIN_PATH/bin:$PATH"
export UV_CACHE_DIR="$FNDSA_M55_ENV/uv-cache"
export UV_PYTHON_INSTALL_DIR="$FNDSA_M55_ENV/python"
# Keep Python bytecode out of the verified upstream source trees.
export PYTHONDONTWRITEBYTECODE=1
