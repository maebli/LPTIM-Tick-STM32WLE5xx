# LPTIM-Tick-STM32WLE5xx

## Introduction

Different examples exist to integrate LPTIM1 as HAL and FreeRTOS time base for low power tickless idle mode. 
I have looked at two. 

### LPTIM FreeRTOS port by ST (on this seperate branc)

This implementation is based on ST example `.\STM32Cube_FW_L4_V1.15.1\Projects\B-L475E-IOT01A\Applications\FreeRTOS\FreeRTOS_LowPower_LPTIM\`
It uses the HAL to enter STOP mode, not optimizing the entry as the other port has done. It uses LPTIM in PWM mode.

#### Testing

This port seems to be working in STOP1/2 and Sleep mode. Further testing, and low power measurements are however pending. 

### LPTIM FreeRTOS port by Jeff Tenney (on master branch currently)

On the master branch I first attempted to ingreate the LPTIM1 tickless FreeRtos port by the user jefftenney to STM32WLxx (specifcally STM32WLE5CCU6).
The gist can be seen at https://gist.github.com/jefftenney/02b313fe649a14b4c75237f925872d72, and there also exists a demo integration
using CubeMx at https://github.com/jefftenney/LPTIM-Tick/tree/d18c796276a6b54cb0d49d5fb32963d0af0dc1a0.  

#### Step by Step Setup 

(1) Create new STM32WLE5CCU6 `*.ioc ` using the CubeMXIDE Wizard 

(2) Add FreeRtos (uses 10.2.1 when I use the wizard) Middleware, configure tasks / timers as required 

(3) Enable LSE and MSI in the clock diagram  

(4) Add Debug pin for toggeling, low level debugging 

(5) Genrate code 

(6) Copy implementation of low power from LTIM-Tick `ulp.c`, `ulp.h`, `ulp.c`, `lptimTick.c`, `FreeRTOSConfig.h` (overwrite existing) 

(7) Add initalization for ulp in `main.c`, disable TIM17 (timebase for HAL) in mainTask (FreeRTOS task), so we don't get interrupted by these 

(8) Adjust `ulp.c` so that it compiles  

  (a) `CLEAR_BIT(RCC->CFGR, RCC_CFGR_STOPWUCK);` is always set, as SYSCLK is MSI 

  (b) ~~`PWR_CR1_LPMS_STOP1` is called `PWR_CR1_LPMS_1` for this MCU~~ *

  (c) ~~`PWR_CR1_LPMS_STOP2` is called `PWR_CR1_LPMS_2` for this MCU~~ *

*(b) & (c) were wrongfully changed, they caused the module to go to SHUTDOWN mode, from which it cannot wake
using the LPTIM1 interrupt*

#### Testing

##### Deep sleep is supressed

By adding the line `vUlpOnPeripheralsActive(1);` in main we can supress deep sleep. 

=> everything runs smoothly LPTIM1 is triggered every 1/2 second.
=> Debug pin is toggled every 1/2 second

##### Deep sleep is not supressed

The `vUlpOnPeripheralsActive(1)` line is removed. Application runs again. 

=> Application never returns from sleep. 
=> Adding debug toggle to interrupt nothing happens LPTIM1 interrupt routine is never
executed. 

*Note* a first attempt was to add RTC alarm, this worked, but should not have to be done, as
LPTIM1 should wake from STOPx mode in the implementation. 

##### Further tests in Deep sleep not suppressed

* Tested using different clock source for LPTIM1, did not solve the issue (LSI instead of LSE)

* explicitly disabling again HAL_Suspend_Ticks(); HAL_Resume_Ticks() before entering STOP2

* Entering only STOP1 instead of STOP2

* Enabling debug mode in STOP/Suspend/Sleep 



