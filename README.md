# LPTIM-Tick-STM32WLE5xx

## Introduction

This is my attempt to ingreate the LPTIM1 tickless FreeRtos port by the user jefftenney to STM32WLxx (specifcally STM32WLE5CCU6).
The gist can be seen at https://gist.github.com/jefftenney/02b313fe649a14b4c75237f925872d72, and there also exists a demo integration
using CubeMx at https://github.com/jefftenney/LPTIM-Tick/tree/d18c796276a6b54cb0d49d5fb32963d0af0dc1a0.  

## Step by Step Setup 

(1) Create new STM32WLE5CCU6 `*.ioc ` using the CubeMXIDE Wizard

(2) Add FreeRtos (uses 10.2.1 when I use the wizard) Middleware, configure tasks / timers as required

(3) Enable LSE and MSI in the clock diagram

(4) Add Debug pin for toggeling, low level debugging

(5) Genrate code

(6) Copy implementation of low power from LTIM-Tick `ulp.c`, `ulp.h`, `ulp.c`, `lptimTick.c`, `FreeRTOSConfig.c` (overwrite existing)

(7) Add initalization for ulp in `main.c`, disable TIM17 (timebase for HAL) in mainTask (FreeRTOS task), so we don't get interrupted by these

(8) Adjust `ulp.c` so that it compiles 

(a) `CLEAR_BIT(RCC->CFGR, RCC_CFGR_STOPWUCK);` is always set, as SYSCLK is MSI
	
(b) `PWR_CR1_LPMS_STOP1` is called `PWR_CR1_LPMS_1` for this MCU
	
(b) `PWR_CR1_LPMS_STOP2` is called `PWR_CR1_LPMS_2` for this MCU


## Testing

### Deep sleep is supressed

By adding the line `vUlpOnPeripheralsActive(1);` in main we can supress deep sleep. 

=> everything runs smoothly LPTIM1 is triggered every 1/2 second.
=> Debug pin is toggled every 1/2 second

### Deep sleep is not supressed

The `vUlpOnPeripheralsActive(1)` line is removed. Application runs again. 

=> Application never returns from sleep. 
=> Adding debug toggle to interrupt nothing happens LPTIM1 interrupt routine is never
executed. 

*Note* a first attepmt was to add RTC alarm, this worked, but should not have to be done, as
LPTIM1 should wake from STOPx mode in the implementation. 



