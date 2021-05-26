################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (9-2020-q2-update)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Core/Startup/startup_stm32wle5ccux.s 

OBJS += \
./Core/Startup/startup_stm32wle5ccux.o 

S_DEPS += \
./Core/Startup/startup_stm32wle5ccux.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Startup/startup_stm32wle5ccux.o: ../Core/Startup/startup_stm32wle5ccux.s Core/Startup/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -c -x assembler-with-cpp -MMD -MP -MF"Core/Startup/startup_stm32wle5ccux.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

